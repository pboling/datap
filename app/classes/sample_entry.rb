class SampleEntry
  attr_reader :id, :url, :referrer, :created_at, :hash
  def initialize(url:, referrers:, index:, first_date:, min_sequential_days: 10)
    @id = index
    @url = url
    @referrer = rand(10) > 3 ? referrers.sample(1) : nil
    @created_at = first_date + index.modulo(min_sequential_days).days
    @hash = to_digest
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