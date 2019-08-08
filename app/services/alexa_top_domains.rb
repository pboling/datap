# frozen_string_literal: true

require 'open-uri'
require 'zip'

# Download, unzip, & save the top ~1MM Alexa-ranked domains, as delineated text file, with roughly 1MM entries
class AlexaTopDomains
  URL = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'
  FILEPATH = 'db/data/domains.txt'
  DEFAULT_SIZE = 100

  attr_reader :domains, :size

  def initialize(size: nil)
    @size = size || DEFAULT_SIZE
    @domains = each
  end

  private

  def cached?
    File.exist?(FILEPATH)
  end

  def get
    HTTParty.get(URL).body
  end

  def extract(zipped)
    unzipped = unzip(zipped)
    write(unzipped['top-1m.csv'])
  end

  def each
    return fill_to_exactly_size.each unless block_given?

    fill_to_exactly_size.each do |domain|
      yield domain
    end
  end

  def read
    File.readlines(FILEPATH, chomp: true)
  end

  def write(unzipped)
    all = unzipped.split.map { |l| l.split(',')[1] }
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

  def fill_to_exactly_size
    extract(get) unless cached?
    ListFiller.new(read, size: size).list
  end
end
