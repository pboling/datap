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
  end
end
