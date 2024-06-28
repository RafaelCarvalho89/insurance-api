# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'json'
gem 'pg'
gem 'rackup'
gem 'rake'
gem 'sinatra', require: 'sinatra/base'

group :development do
  gem 'rubocop', require: false
end

group :development, :test do
  gem 'dotenv'
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov', require: false
end
