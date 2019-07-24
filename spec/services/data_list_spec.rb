RSpec.describe DataList do
  let(:urls) do
    %w(
      http://apple.com
      https://apple.com
      https://www.apple.com
      http://developer.apple.com
    )
  end
  let(:instance) { described_class.new(urls: urls) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end

    it 'fills to 1MM entries' do
      expect(instance.sample_entries).to_not be_empty
      expect(instance.sample_entries.length).to eq(1_000_000)
    end
  end
end
