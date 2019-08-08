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
  let(:sequential_days) { 10 }
  let(:size) { sequential_days }
  let(:instance) { described_class.new(urls: urls, size: size, sequential_days: sequential_days) }

  describe '#initialize' do
    subject { instance }

    it 'does not raise' do
      VCR.use_cassette('alexa_top_domains') do
        block_is_expected.not_to raise_error
      end
    end
    it 'Entries are SampleEntry' do
      VCR.use_cassette('alexa_top_domains') do
        expect(instance.sample_entries.map(&:class).uniq).to eq [SampleEntry]
      end
    end

    context 'with size = sequential_days' do
      subject(:sample_entries) { instance.sample_entries }

      it 'is not empty' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries).not_to be_empty
        end
      end
      it 'fills to <size> entries' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries.length).to eq(size)
        end
      end
    end

    context 'with size > sequential_days' do
      subject(:sample_entries) { instance.sample_entries }

      let(:size) { sequential_days + 1 }

      it 'is not empty' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries).not_to be_empty
        end
      end
      it 'fills to <size> entries' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries.length).to eq(size)
        end
      end
    end

    context 'with size < sequential_days' do
      subject(:sample_entries) { instance.sample_entries }

      let(:size) { sequential_days - 1 }

      it 'raises RuntimeError' do
        VCR.use_cassette('alexa_top_domains') do
          block_is_expected.to raise_error(RuntimeError, "Minimum size is #{sequential_days} when sequential_days is #{sequential_days}")
        end
      end
    end

    context 'with size 149 (prime)' do
      subject(:sample_entries) { instance.sample_entries }

      let(:size) { 149 }

      it 'is not empty' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries).not_to be_empty
        end
      end
      it 'fills to <size> entries' do
        VCR.use_cassette('alexa_top_domains') do
          expect(sample_entries.length).to eq(size)
        end
      end
    end
  end

  describe '#each' do
    subject(:each) { instance.each }

    it 'returns an Enumerator' do
      is_expected.to be_an(Enumerator)
    end

    context 'when converted to array' do
      subject { each.to_a.length }

      let(:size) { 12 }

      it 'has <size> members' do
        is_expected.to eq(size)
      end
    end
  end

  describe '.seeder' do
    subject(:instance) { described_class.seeder(size: size, first_date: first_date, sequential_days: sequential_days) }

    let(:first_date) { Time.zone.now }
    let(:sequential_days) { 17 }

    it 'returns an array' do
      is_expected.to be_an(described_class)
    end

    context 'when size = 149' do
      subject { instance.sample_entries.length }

      let(:size) { 149 }

      it 'has the same number of sample entries' do
        is_expected.to eq(size)
      end
    end
  end
end
