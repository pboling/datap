# frozen_string_literal: true

class TopReferrersController < ApplicationController
  def index
    render json: PageView.top_referrers.as_json
  end
end
