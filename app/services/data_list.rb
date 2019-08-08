# frozen_string_literal: true

require 'colorized_string'

# We need a list of exactly one million entries
class DataList # rubocop:disable Metrics/ClassLength
  CORE_REFERRERS = %w[
    http://apple.com
    https://apple.com
    https://www.apple.com
    http://developer.apple.com
  ].freeze
  CORE_URLS = %w[
    http://apple.com
    https://apple.com
    https://www.apple.com
    http://developer.apple.com
    http://en.wikipedia.org
    http://opensource.org
  ].freeze
  REQUIRED_REFERRERS = CORE_REFERRERS + [nil]
  BASE_SITE_URL = 'https://developer.apple.com'
  ERROR_PATH = '/error'
  BAD_URI_PATH = '/lulz'
  ROOT_PATH = '/'
  MINIMUM_LIST_SIZE = 10
  PRINT_EVERY_X = 10_000
  RED_DOT = ColorizedString['.'].red.on_yellow
  COLUMNS = %i[id url referrer created_at digest].freeze
  attr_reader :urls, :size, :sample_entries, :first_date, :sequential_days

  class << self
    # returns an array of hashes
    # each hash will have keys like the attributes of SampleEntry
    #
    # rubocop:disable Rails/Output, Metrics/MethodLength
    def seeder(size:, sequential_days:, first_date: nil, print_every_x: PRINT_EVERY_X)
      top_domains = AlexaTopDomains.new(size: size)
      puts "Entropy source is #{top_domains.domains.size} data points"
      puts "Each '#{DataList::RED_DOT}' represents 10,000 page views prepared\n"
      puts '.' * (1_000_000 / print_every_x) + ' 100%'
      new(
        urls: top_domains.domains,
        size: size,
        first_date: first_date,
        sequential_days: sequential_days,
        print_every_x: print_every_x
      )
    end
    # rubocop:enable Rails/Output, Metrics/MethodLength
  end

  def initialize(urls:, size:, first_date: nil, sequential_days: MINIMUM_LIST_SIZE, print_every_x: PRINT_EVERY_X) # rubocop:disable Metrics/AbcSize
    # Must be at least ten sequential days of data
    raise 'Minimum sequential_days is 10' unless sequential_days >= MINIMUM_LIST_SIZE
    raise "Minimum size is #{sequential_days} when sequential_days is #{sequential_days}" unless size >= sequential_days

    @size = size
    @urls = ListFiller.new(urls.to_a, size: @size).list
    @non_core_referrers = ListEntropy.new(@urls.first(1000), size: 1000, max_entropy: 1000).list
    @sample_entries = []
    @first_date = first_date || Time.zone.now.beginning_of_day - sequential_days.days
    @sequential_days = sequential_days
    fill_sample_entries(print_every_x)
  end

  def each
    return enum_for(:each) unless block_given?

    sample_entries.each do |entry|
      yield entry.to_a
    end
  end

  private

  def fill_sample_entries(print_every_x)
    must_have_referrers = REQUIRED_REFERRERS.dup
    must_have_urls = CORE_URLS.dup
    @urls.each_with_index do |top_url, index|
      add_sample_entry!(must_have_urls, must_have_referrers, top_url, index, print_every_x)
    end
  end

  def add_sample_entry!(must_have_urls, must_have_referrers, top_url, index, print_every_x)
    visited_url = next_url!(must_have_urls, top_url)
    referrer = next_referrer!(must_have_referrers, visited_url)
    @sample_entries << SampleEntry.new(
      url: visited_url,
      referrer: referrer,
      index: index,
      first_date: first_date,
      sequential_days: sequential_days
    )
    progress(index, print_every_x)
  end

  def progress(index, print_every_x)
    print RED_DOT if index.modulo(print_every_x).zero? # rubocop:disable Rails/Output
  end

  def next_referrer!(must_have_referrers, visited_url)
    must_have = must_have_referrers.shift
    return nil if must_have == visited_url
    return must_have if must_have
    return nil unless decide_if_has_referrer?

    referrer = if decide_if_own_referrer?
                 CORE_REFERRERS.sample
               else
                 "#{random_scheme}://#{@non_core_referrers.sample}"
               end
    return referrer unless referrer == visited_url
  end

  def next_url!(must_have_urls, top_url)
    must_have = must_have_urls.shift
    return top_url if must_have == top_url
    return must_have if must_have

    return CORE_URLS.sample if decide_if_hit_core_domain_at_root?

    "#{CORE_URLS.sample}#{faux_path(top_url)}"
  end

  # Use "random" hostname from the Alexa top 1MM as entropy in the data
  def faux_path(url)
    return ROOT_PATH unless url

    uri = Addressable::URI.parse("#{random_scheme}://#{url}")
    return BAD_URI_PATH unless uri

    hostname = uri.hostname.try(:gsub, '.', '/')
    hostname = "/#{hostname}" if hostname
    hostname || ERROR_PATH
  end

  def random_scheme
    decide_if_secure_scheme? ? 'https' : 'http'
  end

  def decide_if_secure_scheme?
    rand(10) < 6
  end

  # A plurality of referrers should be from the same domain
  def decide_if_own_referrer?
    rand(10) < 5
  end

  # A majority of entries should have referrers
  def decide_if_has_referrer?
    rand(10) > 2
  end

  # A plurality of entries should be for root core domain
  def decide_if_hit_core_domain_at_root?
    rand(10) < 4
  end
end
