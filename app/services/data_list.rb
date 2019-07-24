# We need a list of exactly one million entries
class DataList
  REQUIRED_REFERRERS = %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    )
  attr_reader :urls, :sample_entries, :first_date, :min_sequential_days

  def initialize(urls:, first_date: nil, min_sequential_days: 10)
    @urls = urls
    @sample_entries = []
    @first_date = first_date || Time.now.beginning_of_day
    @min_sequential_days = min_sequential_days
    fill_to_exactly_1MM_urls
    fill_sample_entries
  end

  private

  def fill_sample_entries
    @urls.each_with_index do |url, index|
      @sample_entries << SampleEntry.new(
        url: url,
        referrers: urls | REQUIRED_REFERRERS,
        index: index,
        first_date: first_date,
        min_sequential_days: min_sequential_days
      )
    end
  end

  def fill_to_exactly_1MM_urls
    num_missing_domains = 1_000_000 - urls.length
    case num_missing_domains <=> 0
    when -1 then # LT, i.e. there are too many
      urls.pop(num_missing_domains)
    when 0 then # EQ
    when 1 then # GT, i.e. there are not enough
      while (rem = 1_000_000 - urls.length)
        urls.concat(urls.sample(rem))
      end
    else
      raise "Unexpected Comparison"
    end
  end
end