# frozen_string_literal: true

RSpec.describe DataList do
  let(:urls) do
    %w[
      http://mars.com
      https://venus.com
      https://jupiter.com
      http://neptune.com
    ]
  end
  let(:size) { 20 }
  let(:instance) { described_class.new(urls: urls, size: size) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      VCR.use_cassette('alexa_top_domains') do
        block_is_expected.to_not raise_error
      end
    end

    it 'fills to <size> entries' do
      VCR.use_cassette('alexa_top_domains') do
        expect(instance.sample_entries).to_not be_empty
        expect(instance.sample_entries.length).to eq(size)
      end
    end

    it 'Entries are SampleEntry' do
      VCR.use_cassette('alexa_top_domains') do
        expect(instance.sample_entries.map(&:class).uniq).to eq [SampleEntry]
      end
    end
    context 'with size 50' do
      let(:size) { 50 }
      it 'fills to <size> entries' do
        VCR.use_cassette('alexa_top_domains') do
          expect(instance.sample_entries).to_not be_empty
          expect(instance.sample_entries.length).to eq(size)
        end
      end
    end
    context 'with size 149 (prime)' do
      let(:size) { 149 }
      it 'fills to <size> entries' do
        VCR.use_cassette('alexa_top_domains') do
          expect(instance.sample_entries).to_not be_empty
          expect(instance.sample_entries.length).to eq(size)
        end
      end
    end
  end

  describe '#each' do
    subject { instance.each }
    it 'returns an Enumerator' do
      is_expected.to be_an(Enumerator)
    end
    context 'converts to array' do
      let(:size) { 12 }
      subject { instance.each.to_a.length }
      it 'is size' do
        is_expected.to eq(size)
      end
    end
  end

  describe '.seeder' do
    let(:first_date) { Time.now }
    let(:sequential_days) { 17 }
    subject(:instance) { described_class.seeder(size: size, first_date: first_date, sequential_days: sequential_days) }
    it 'returns an array' do
      is_expected.to be_an(described_class)
    end
    context 'has <size> sample entries' do
      let(:size) { 149 }
      subject { instance.sample_entries.length }
      it 'is size' do
        is_expected.to eq(size)
      end
    end
  end
end
