require 'open-uri'
require 'zip'

class AlexaTopDomains
  URL = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'
  FILEPATH = 'db/data/domains.txt'

  attr_reader :domains, :num

  def initialize(size: nil)
    @domains = as_enum
    @num = size ? size - 1 : -1
  end

  private

  def cached?
    File.exist?(FILEPATH)
  end

  def as_enum
    return each if cached?

    extract(get)
    each
  end

  def get
    HTTParty.get(URL).body
  end

  def extract(zipped)
    unzipped = unzip(zipped)
    write(unzipped["top-1m.csv"])
  end

  def each
    return read.each unless block_given?

    read[0..(num)].each do |domain|
      yield domain
    end
  end

  def read
    File.readlines(FILEPATH, chomp: true)
  end

  def write(unzipped)
    all = unzipped.split.map { |l| l.split(",")[1] }
    File.open(FILEPATH, 'w') do |file|
      file.puts all.join("\n")
    end
  end

  def unzip(zipped)
    {}.tap do |entries|
      Zip::InputStream.open(StringIO.new(zipped)) do |io|
        while (entry = io.get_next_entry)
          # name is "top-1m.csv"
          entries[entry.name] = io.read
        end
      end
    end
  end
end