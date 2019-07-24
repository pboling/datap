RSpec.describe AlexaTopDomains do
  let(:instance) { described_class.new }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end
    context 'initial values' do
      describe 'domains' do
        subject { instance.domains }
        it 'sets' do
          is_expected.to eq([])
        end
      end
    end
  end

  describe '#fetch' do
    subject { instance.fetch }
    it 'has almost a million domains' do
      VCR.use_cassette("alexa_top_domains") do
        # Normally I would VCR the response from Alexa, which is about 9.3 MB in size.
        # Since I haven't done that here (yet),
        #   I am combining multiple tests into a single spec,
        #   so as to not offend networks / Amazon / Jeff Bezos
        block_is_expected.to_not raise_error
        expect(instance.domains).to_not be_empty
        expect(instance.domains.length > 990_000).to be true
      end
    end
  end
end