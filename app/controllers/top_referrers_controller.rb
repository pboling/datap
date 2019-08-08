# frozen_string_literal: true

# API for top 5 referrers for each of the top 10 URLs, grouped by day, for the past 5 days
class TopReferrersController < ApplicationController
  def index
    render json: PageView.top_referrers.as_json
  end
end
