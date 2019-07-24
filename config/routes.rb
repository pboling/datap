# frozen_string_literal: true

Rails.application.routes.draw do
  resources :page_views
  resource :top_urls, only: [:index]
  resource :top_referrers, only: [:index]
end
