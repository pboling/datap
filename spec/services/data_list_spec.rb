RSpec.describe DataList do
  let(:urls) do
    %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    )
  end
  let(:size) { 20 }
  let(:instance) { described_class.new(urls: urls, size: size) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      VCR.use_cassette("alexa_top_domains") do
        block_is_expected.to_not raise_error
      end
    end

    it 'fills to <size> entries' do
      VCR.use_cassette("alexa_top_domains") do
        expect(instance.sample_entries).to_not be_empty
        expect(instance.sample_entries.length).to eq(size)
      end
    end

    it 'Entries are SampleEntry' do
      VCR.use_cassette("alexa_top_domains") do
        expect(instance.sample_entries.map(&:class).uniq).to eq [SampleEntry]
      end
    end
    context 'with size 50' do
      let(:size) { 50 }
      it 'fills to <size> entries' do
        VCR.use_cassette("alexa_top_domains") do
          expect(instance.sample_entries).to_not be_empty
          expect(instance.sample_entries.length).to eq(size)
        end
      end
    end
    context 'with size 149 (prime)' do
      let(:size) { 149 }
      it 'fills to <size> entries' do
        VCR.use_cassette("alexa_top_domains") do
          expect(instance.sample_entries).to_not be_empty
          expect(instance.sample_entries.length).to eq(size)
        end
      end
    end
  end

  describe '#to_a' do
    subject { instance.to_a }
    it 'returns an array' do
      is_expected.to be_an(Array)
    end
    context 'length' do
      let(:size) { 149 }
      subject { instance.to_a.length }
      it 'is size' do
        is_expected.to eq(size)
      end
    end
  end

  describe '.seeder' do
    let(:first_date) { Time.now }
    let(:min_sequential_days) { 17 }
    subject(:instance) { described_class.seeder(size: size, first_date: first_date, min_sequential_days: min_sequential_days) }
    it 'returns an array' do
      is_expected.to be_an(Array)
    end
    context 'length' do
      let(:size) { 149 }
      subject { instance.length }
      it 'is size' do
        is_expected.to eq(size)
      end
    end
  end
end
