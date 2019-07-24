# We need a list of exactly one million entries
class DataList
  REQUIRED_REFERRERS = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    ) << nil
  BASE_SITE_URL = 'https://developer.apple.com'
  attr_reader :urls, :size, :sample_entries, :first_date, :min_sequential_days

  def initialize(urls:, size: 1_000_000, first_date: nil, min_sequential_days: 10)
    @urls = urls.dup # array will be modified
    @size = size
    @sample_entries = []
    @first_date = first_date || Time.now.beginning_of_day
    @min_sequential_days = min_sequential_days
    fill_to_exactly_1MM_urls
    fill_sample_entries
  end

  private

  def fill_sample_entries
    must_have_referrers = REQUIRED_REFERRERS.dup
    @urls.each_with_index do |url, index|
      @sample_entries << SampleEntry.new(
        url: next_url!(url),
        referrer: next_referrer!(must_have_referrers),
        index: index,
        first_date: first_date,
        min_sequential_days: min_sequential_days
      )
    end
  end

  def next_referrer!(must_have_referrers)
    must_have_referrers.shift ||
        has_referrer? ? urls.sample : nil
  end

  def next_url!(url)
    return BASE_SITE_URL if hit_root?
    "#{BASE_SITE_URL}/#{faux_path(url)}"
  end

  # Use "random" hostname from the Alexa top 1MM as entropy in the data
  def faux_path(url)
    Addressable::URI.parse(url).hostname.gsub('.', '/')
  end

  # A majority of entries should have referrers
  def has_referrer?
    rand(10) > 3
  end

  # A plurality of entries should be for site root
  def hit_root?
    rand(10) < 4
  end

  def fill_to_exactly_1MM_urls
    num_missing_domains = size - urls.length
    case num_missing_domains <=> 0
    when -1 then # LT, i.e. there are too many
      urls.pop(num_missing_domains)
    when 0 then # EQ
    when 1 then # GT, i.e. there are not enough
      while (rem = size - urls.length) > 0
        urls.concat(urls.sample(rem))
      end
    else
      raise "Unexpected Comparison"
    end
  end
end