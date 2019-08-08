# frozen_string_literal: true

RSpec.describe AlexaTopDomains do
  let(:instance) { described_class.new }

  describe '#initialize' do
    subject { instance }

    it 'does not raise' do
      VCR.use_cassette('alexa_top_domains') do
        block_is_expected.not_to raise_error
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
        context 'default' do
          let(:instance) { described_class.new(size: nil) }

          it 'size is DEFAULT_SIZE' do
            VCR.use_cassette('alexa_top_domains') do
              expect(instance.domains.size).to eq(described_class::DEFAULT_SIZE)
            end
          end
        end

        context 'large' do
          let(:size) { 1_111_111 }
          let(:instance) { described_class.new(size: size) }

          it 'size is large' do
            VCR.use_cassette('alexa_top_domains') do
              expect(instance.domains.size).to eq(size)
            end
          end
        end
      end
    end
  end
end
