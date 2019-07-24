# We need a list of exactly one million entries
class DataList
  CORE_REFERRERS = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    )
  CORE_URLS = %w(
    http://apple.com
    https://apple.com
    https://www.apple.com
    http://developer.apple.com
    http://en.wikipedia.org
    http://opensource.org
  )
  REQUIRED_REFERRERS = CORE_REFERRERS << nil
  BASE_SITE_URL = 'https://developer.apple.com'
  ERROR_PATH = '/error'
  BAD_URI_PATH = '/lulz'
  ROOT_PATH = '/'
  MINIMUM_LIST_SIZE = 10
  COLUMNS = [:id, :url, :referrer, :created_at, :digest]
  attr_reader :urls, :size, :sample_entries, :first_date, :min_sequential_days

  class << self
    # returns an array of hashes
    # each hash will have keys like the attributes of SampleEntry
    def seeder(size:, first_date:, min_sequential_days:)
      top_domains = AlexaTopDomains.new(size: size)
      puts "Have #{top_domains.num + 1} Domains"
      self.new(
          urls: top_domains.domains,
          size: size,
          first_date: first_date,
          min_sequential_days: min_sequential_days
      )
    end
  end

  def initialize(urls:, size:, first_date: nil, min_sequential_days: MINIMUM_LIST_SIZE)
    # Must be at least ten sequential days of data
    raise 'Minimum min_sequential_days is 10' unless min_sequential_days >= MINIMUM_LIST_SIZE
    raise "Minimum size is #{min_sequential_days} when min_sequential_days is #{min_sequential_days}" unless size >= min_sequential_days

    @urls = urls.to_a
    @size = size
    @sample_entries = []
    @first_date = first_date || Time.now.beginning_of_day - min_sequential_days
    @min_sequential_days = min_sequential_days
    fill_to_exactly_size
    fill_sample_entries
  end

  def each
    return enum_for(:each) unless block_given?

    sample_entries.each do |entry|
      yield entry.to_a
    end
  end

  private

  def fill_sample_entries
    must_have_referrers = REQUIRED_REFERRERS.dup
    must_have_urls = CORE_URLS.dup
    @urls.each_with_index do |top_url, index|
      visited_url = next_url!(must_have_urls, top_url)
      referrer = next_referrer!(must_have_referrers, visited_url)
      @sample_entries << SampleEntry.new(
        url: visited_url,
        referrer: referrer,
        index: index,
        first_date: first_date,
        min_sequential_days: min_sequential_days
      )
    end
  end

  def next_referrer!(must_have_referrers, visited_url)
    must_have = must_have_referrers.shift
    return nil if must_have == visited_url
    return must_have if must_have
    return nil unless has_referrer?

    if own_referrer?
      referrer = CORE_REFERRERS.sample
    else
      scheme = secure_scheme? ? 'https' : 'http'
      referrer = "#{scheme}://#{urls.sample}"
    end
    return referrer unless referrer == visited_url
  end

  def next_url!(must_have_urls, top_url)
    must_have = must_have_urls.shift
    return top_url if must_have == top_url
    return must_have if must_have

    return CORE_URLS.sample if hit_core_domain_at_root?

    "#{CORE_URLS.sample}#{faux_path(top_url)}"
  end

  # Use "random" hostname from the Alexa top 1MM as entropy in the data
  def faux_path(url)
    return ROOT_PATH unless url

    scheme = secure_scheme? ? 'https' : 'http'
    uri = Addressable::URI.parse("#{scheme}://#{url}")
    return BAD_URI_PATH unless uri

    hostname = uri.hostname.try(:gsub, '.', '/')
    hostname = "/#{hostname}" if hostname
    hostname || ERROR_PATH
  end

  def secure_scheme?
    rand(10) < 6
  end

  # A plurality of referrers should be from the same domain
  def own_referrer?
    rand(10) < 3
  end

  # A majority of entries should have referrers
  def has_referrer?
    rand(10) > 3
  end

  # A plurality of entries should be for root core domain
  def hit_core_domain_at_root?
    rand(10) < 4
  end

  def fill_to_exactly_size
    num_missing_domains = size - urls.length
    case num_missing_domains <=> 0
    when -1 then # LT, i.e. there are too many
      urls.pop(-num_missing_domains)
    when 0 then # EQ
      puts "Perfectly #{size}"
    when 1 then # GT, i.e. there are not enough
      while (rem = size - urls.length).positive?
        urls.concat(urls.sample(rem))
      end
    else
      raise 'Unexpected Comparison'
    end
  end
end