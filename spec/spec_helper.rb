# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require_relative '../app/application'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Application.new
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
end
