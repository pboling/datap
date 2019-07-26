# frozen_string_literal: true

class TopUrlsController < ApplicationController
  def index
    render json: PageView.top_urls.as_json
  end
end
