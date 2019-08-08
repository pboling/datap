# frozen_string_literal: true

# Allows creation of the hash of attributes used to create a PageView record
# Facilitates creating PageView records that are realistic looking
class SampleEntry
  attr_reader :id, :url, :referrer, :created_at, :digest
  def initialize(url:, referrer:, index:, first_date:, sequential_days: 10)
    # index starts at 0, but ID starts at 1
    @id = index + 1
    @url = url
    @referrer = referrer
    @created_at = random_time_of_day(first_date + index.modulo(sequential_days).days)
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

  def to_a
    [id, url, referrer, created_at, digest]
  end

  private

  def random_time_of_day(now)
    from = now.strftime('%Y-%m-%dT00:00:00%z')
    to = now.strftime('%Y-%m-%dT11:59:59%z')
    rand(Time.zone.parse(from)..Time.zone.parse(to))
  end

  def to_digest
    Digest::MD5.hexdigest(
      {
        id: id,
        url: url,
        referrer: referrer,
        created_at: created_at
      }.compact!.to_s
    )
  end
end
