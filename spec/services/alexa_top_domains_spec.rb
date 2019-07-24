# frozen_string_literal: true

RSpec.describe AlexaTopDomains do
  let(:instance) { described_class.new }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      VCR.use_cassette('alexa_top_domains') do
        block_is_expected.to_not raise_error
      end
    end
    context 'initial values' do
      describe 'domains' do
        subject { instance.domains }
        it 'is an enumerator' do
          VCR.use_cassette('alexa_top_domains') do
            is_expected.to be_a(Enumerator)
          end
        end
        it 'has almost a million domains' do
          VCR.use_cassette('alexa_top_domains') do
            expect(instance.domains.size > 990_000).to be true
          end
        end
      end
    end
  end
end
