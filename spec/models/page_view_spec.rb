# frozen_string_literal: true

RSpec.describe PageView do
  let(:instance) { described_class.new }

  describe '#initialize' do
    subject { instance }

    it 'does not raise error' do
      block_is_expected.not_to raise_error
    end
  end

  describe '#top_urls' do
    subject(:top_urls) { described_class.top_urls }

    it 'does not raise error' do
      block_is_expected.not_to raise_error
    end
    it 'returns an Hash' do
      is_expected.to be_a(Hash)
    end
    context 'with data' do
      # Get a seeded DB by running one of:
      #   RAILS_ENV=test bin/rake db:seed
      #   RAILS_ENV=test bin/rake db:reset
      #
      # Ensure  1,000,000 records!
      it 'is seeded' do
        expect(described_class.count).to eq(1_000_000)
      end
      it 'is not empty' do
        is_expected.not_to be_empty
      end
      it 'has keys in the most visited site ' do
        first_day = top_urls.keys[0]
        expect(top_urls[first_day].first.keys).to eq(%i[url visits])
      end
      # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      it 'sequential dates' do
        # NOTE: The DB must be seeded every day, to keep the leading edge of the data fresh
        #       This test suite validates a "production prototype, so it has to be realistic"
        #       Timecop can't be used to fake it because the DB queries use magic:
        #         CURRENT_DATE - INTERVAL '#{days_ago} days'
        first_day_result = Date.parse(top_urls.keys[0])
        second_day_result = Date.parse(top_urls.keys[1])
        third_day_result = Date.parse(top_urls.keys[2])
        fourth_day_result = Date.parse(top_urls.keys[3])
        last_day_result = Date.parse(top_urls.keys[-1]) # fifth is last!

        # Ensure 5 days of data
        expect(first_day_result - second_day_result).to eq(1)
        expect(first_day_result - third_day_result).to eq(2)
        expect(first_day_result - fourth_day_result).to eq(3)
        expect(first_day_result - last_day_result).to eq(4)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
    end
  end

  describe '#top_referrers' do
    subject(:top_referrers) { described_class.top_referrers }

    it 'does not raise error' do
      block_is_expected.not_to raise_error
    end
    it 'returns an Hash' do
      is_expected.to be_a(Hash)
    end
    context 'with data' do
      # Get a seeded DB by running one of:
      #   RAILS_ENV=test bin/rake db:seed
      #   RAILS_ENV=test bin/rake db:reset
      #
      # Ensure  1,000,000 records!
      it 'is seeded' do
        expect(described_class.count).to eq(1_000_000)
      end
      it 'is not empty' do
        is_expected.not_to be_empty
      end
      it 'has keys in the most visited site ' do
        first_day = top_referrers.keys[0]
        expect(top_referrers[first_day].first.keys).to eq(%i[url visits referrers])
      end
      # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
      it 'sequential dates' do
        # NOTE: The DB must be seeded every day, to keep the leading edge of the data fresh
        #       This test suite validates a "production prototype, so it has to be realistic"
        #       Timecop can't be used to fake it because the DB queries use magic:
        #         CURRENT_DATE - INTERVAL '#{days_ago} days'
        first_day_result = Date.parse(top_referrers.keys[0])
        second_day_result = Date.parse(top_referrers.keys[1])
        third_day_result = Date.parse(top_referrers.keys[2])
        fourth_day_result = Date.parse(top_referrers.keys[3])
        last_day_result = Date.parse(top_referrers.keys[-1]) # fifth is last!

        # Ensure 5 days of data
        expect(first_day_result - second_day_result).to eq(1)
        expect(first_day_result - third_day_result).to eq(2)
        expect(first_day_result - fourth_day_result).to eq(3)
        expect(first_day_result - last_day_result).to eq(4)
      end
      # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

      describe 'referrers' do
        subject(:referrers) do
          top = described_class.top_referrers
          first_day = top.keys.first
          top[first_day][0][:referrers]
        end

        it 'is an array' do
          is_expected.to be_a(Array)
        end
        it 'is not empty' do
          is_expected.not_to be_empty
        end
        it 'has keys' do
          expect(referrers.first.keys).to eq(%i[url visits])
        end
        it 'has positive visits' do
          expect(referrers.first[:visits]).to be_positive
        end
      end
    end
  end
end
