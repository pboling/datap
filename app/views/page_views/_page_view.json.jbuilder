# frozen_string_literal: true

json.extract! page_view, :id, :url, :referrer, :hash, :created_at, :created_at, :updated_at
json.url page_view_url(page_view, format: :json)
