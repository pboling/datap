# frozen_string_literal: true

class TopUrlsController < ApplicationController
  def index
    top_urls = PageView.order(created_at: :desc)
    render json: {}
  end
end
