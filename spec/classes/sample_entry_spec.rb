RSpec.describe SampleEntry do
  let(:url) { 'https://developer.apple.com' }
  let(:referrer) { 'https://www.apple.com' }
  let(:index) { 325 }
  let(:first_date) { Time.now }
  let(:sequential_days) { 2 }
  let(:instance) do
    described_class.new(
      url: url,
      referrer: referrer,
      index: index,
      first_date: first_date,
      sequential_days: sequential_days
    )
  end
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      VCR.use_cassette("alexa_top_domains") do
        block_is_expected.to_not raise_error
      end
    end
    context 'initial values' do
      describe 'id' do
        subject { instance.id }
        it 'sets' do
          is_expected.to eq(index)
        end
      end
      describe 'url' do
        subject { instance.url }
        it 'sets' do
          is_expected.to eq(url)
        end
      end
      describe 'referrer' do
        subject { instance.referrer }
        it 'sets' do
          is_expected.to eq(referrer)
        end
      end
      describe 'created_at' do
        subject { instance.created_at }
        it 'sets' do
          is_expected.to be_a(Time)
        end
        it 'is within sequential days' do
          is_expected.to be_within(sequential_days.days).of(first_date.beginning_of_day)
        end
      end
      describe 'digest' do
        subject { instance.digest }
        it 'sets' do
          is_expected.to match(/[a-z0-9]+/)
        end
      end
    end
  end
end
