class SampleEntry
  attr_reader :id, :url, :referrer, :created_at, :digest
  def initialize(url:, referrer:, index:, first_date:, min_sequential_days: 10)
    @id = index
    @url = url
    @referrer = referrer
    @created_at = random_time_of_day(first_date + index.modulo(min_sequential_days).days)
    @digest = to_digest
  end

  def to_h
    {
      id: id,
      url: url,
      referrer: referrer,
      created_at: created_at,
      digest: digest
    }
  end

  private

  def random_time_of_day(now)
    from = now.strftime("%Y-%m-%dT00:00:00%z")
    to = now.strftime("%Y-%m-%dT11:59:59%z")
    rand(Time.parse(from)..Time.parse(to))
  end

  def to_digest
    Digest::MD5.hexdigest(
        {
            id: id,
            url: url,
            referrer: referrer,
            created_at: created_at
        }.to_s
    )
  end
end