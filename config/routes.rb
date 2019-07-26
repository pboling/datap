# frozen_string_literal: true

Rails.application.routes.draw do
  get '/top_urls' => 'top_urls#index'
  get '/top_referrers' => 'top_referrers#index'
end
