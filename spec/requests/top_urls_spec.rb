# frozen_string_literal: true

RSpec.describe 'Top URLs', type: :request do
  let(:headers) do
    {
      'ACCEPT': 'application/json'
    }
  end

  it 'has content type of JSON' do
    get '/top_urls', headers: headers

    expect(response.content_type).to eq('application/json')
  end

  it 'is successful' do
    get '/top_urls', headers: headers

    expect(response).to have_http_status(:ok)
  end
  # NOTE: The DB must be seeded every day, to keep the leading edge of the data fresh
  #       This test suite validates a "production prototype", so it has to be "realistic"
  #       Timecop can't be used to fake it because the DB queries use magic:
  #         CURRENT_DATE - INTERVAL '#{days_ago} days'
  #
  # Get a seeded DB by running one of:
  #   RAILS_ENV=test bin/rake db:seed
  #   RAILS_ENV=test bin/rake db:reset
  #
  # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
  it 'returns data' do
    get '/top_urls', headers: headers

    json = JSON.parse(response.body)
    first_day_result = Date.parse(json.keys[0])
    second_day_result = Date.parse(json.keys[1])
    third_day_result = Date.parse(json.keys[2])
    fourth_day_result = Date.parse(json.keys[3])
    last_day_result = Date.parse(json.keys[-1]) # fifth is last!

    # Ensure 5 days of data
    expect(first_day_result - second_day_result).to eq(1)
    expect(first_day_result - third_day_result).to eq(2)
    expect(first_day_result - fourth_day_result).to eq(3)
    expect(first_day_result - last_day_result).to eq(4) # 4 days between first and last day, for 5 full days total
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
end
