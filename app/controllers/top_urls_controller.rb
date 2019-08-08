# frozen_string_literal: true

# API for top urls by number of visits in the last 5 days
class TopUrlsController < ApplicationController
  def index
    render json: PageView.top_urls.as_json
  end
end
