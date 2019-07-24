# We need a list of exactly one million entries
class DataList
  APPLE_REFERRERS = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    )
  REQUIRED_REFERRERS = APPLE_REFERRERS << nil
  BASE_SITE_URL = 'https://developer.apple.com'
  ERROR_PATH = '/error'
  BAD_URI_PATH = '/lulz'
  ROOT_PATH = '/'
  COLUMNS = [:id, :url, :referrer, :created_at, :digest]
  attr_reader :urls, :size, :sample_entries, :first_date, :min_sequential_days

  class << self
    # returns an array of hashes
    # each hash will have keys like the attributes of SampleEntry
    def seeder(size:, first_date:, min_sequential_days:)
      top_domains = AlexaTopDomains.new(size: size)
      data_list = self.new(
          urls: top_domains.domains,
          size: size,
          first_date: first_date,
          min_sequential_days: min_sequential_days
      )
      data_list.to_a
    end
  end

  def initialize(urls:, size:, first_date: nil, min_sequential_days: 10)
    @urls = urls.to_a
    @size = size
    @sample_entries = []
    @first_date = first_date || Time.now.beginning_of_day - min_sequential_days
    @min_sequential_days = min_sequential_days
    fill_to_exactly_size
    fill_sample_entries
  end

  def to_a
    sample_entries.map(&:to_h)
  end

  private

  def fill_sample_entries
    must_have_referrers = REQUIRED_REFERRERS.dup
    @urls.each_with_index do |url, index|
      url = next_url!(url)
      referrer = next_referrer!(must_have_referrers, url)
      @sample_entries << SampleEntry.new(
        url: url,
        referrer: referrer,
        index: index,
        first_date: first_date,
        min_sequential_days: min_sequential_days
      )
    end
  end

  def next_referrer!(must_have_referrers, url)
    must_have = must_have_referrers.shift
    return nil if must_have == url
    return must_have if must_have
    return nil unless has_referrer?

    if own_referrer?
      referrer = APPLE_REFERRERS.sample
    else
      scheme = secure_referrer? ? 'https' : 'http'
      referrer = "#{scheme}://#{urls.sample}"
    end
    return referrer unless referrer == url
  end

  def next_url!(url)
    return BASE_SITE_URL if hit_root?

    "#{BASE_SITE_URL}#{faux_path(url)}"
  end

  # Use "random" hostname from the Alexa top 1MM as entropy in the data
  def faux_path(url)
    return ROOT_PATH unless url
    return BAD_URI_PATH unless (uri = Addressable::URI.parse(url))

    uri.hostname.try(:gsub, '.', '/') || ERROR_PATH
  end

  def secure_referrer?
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

  # A plurality of entries should be for site root
  def hit_root?
    rand(10) < 4
  end

  def fill_to_exactly_size
    num_missing_domains = size - urls.length
    case num_missing_domains <=> 0
    when -1 then # LT, i.e. there are too many
      urls.pop(-num_missing_domains)
    when 0 then # EQ
    when 1 then # GT, i.e. there are not enough
      while (rem = size - urls.length).positive?
        urls.concat(urls.sample(rem))
      end
    else
      raise 'Unexpected Comparison'
    end
  end
end