require 'zip'

class AlexaTopDomains
  URL = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'

  attr_reader :domains

  def initialize
    @raw = {}
    @domains = []
  end

  def fetch
    extract(get)
  end

  private

  def get
    HTTParty.get(URL).body
  end

  def extract(zipped)
    unzip(zipped)
    @domains = @raw.first[1].split.map { |l| l.split(",")[1] }
  end

  def each
    return enum_for(:each) unless block_given?

    @domains.each do |domain|
      yield domain
    end
  end

  def unzip(zipped)
    @raw.tap do |entries|
      Zip::InputStream.open(StringIO.new(zipped)) do |io|
        while (entry = io.get_next_entry)
          # name is "top-1m.csv"
          entries[entry.name] = io.read
        end
      end
    end
  end
end