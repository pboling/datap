# frozen_string_literal: true

RSpec.describe AlexaTopDomains do
  subject(:instance) { described_class.new }

  describe '#initialize' do
    it 'does not raise' do
      VCR.use_cassette('alexa_top_domains') do
        block_is_expected.not_to raise_error
      end
    end
    describe 'domains' do
      subject(:domains) { instance.domains }

      it 'is an enumerator' do
        VCR.use_cassette('alexa_top_domains') do
          is_expected.to be_a(Enumerator)
        end
      end

      context 'when size arg is not provided' do
        it 'size is DEFAULT_SIZE' do
          VCR.use_cassette('alexa_top_domains') do
            expect(domains.size).to eq(described_class::DEFAULT_SIZE)
          end
        end
      end

      context 'when size arg is nil' do
        subject(:domains) { described_class.new(size: size).domains }

        let(:size) { nil }

        it 'size is DEFAULT_SIZE' do
          VCR.use_cassette('alexa_top_domains') do
            expect(domains.size).to eq(described_class::DEFAULT_SIZE)
          end
        end
      end

      context 'when size arg is large' do
        subject(:domains) { described_class.new(size: size).domains }

        let(:size) { 1_111_111 }

        it 'size is large' do
          VCR.use_cassette('alexa_top_domains') do
            expect(domains.size).to eq(size)
          end
        end
      end
    end
  end
end
