RSpec.describe AlexaTopDomains do
  let(:instance) { described_class.new }
  describe 'initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
  end
end