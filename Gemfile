# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'pg', '>= 0.18'
gem 'puma', '~> 3.11'
gem 'rails', '5.2.3'
gem 'sass-rails', '~> 5.0'

gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'turbolinks', '~> 5'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'rails-i18n'

gem 'sidekiq'
gem 'sidekiq-failures'

gem 'friendly_id'
gem 'komponent'

gem 'activerecord-import'
gem 'httparty'
gem 'rubyzip'
gem 'addressable'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-block_is_expected'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'annotate'
  gem 'awesome_print'
  gem 'bullet'
  gem 'rails-erd'

  gem 'brakeman', require: false
  gem 'overcommit'

  gem 'guard'
  gem 'guard-bundler', require: false
  gem 'guard-livereload', require: false
  gem 'rack-livereload'

  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console', '>= 3.3.0'
end
