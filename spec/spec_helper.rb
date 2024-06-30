# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

ENV['RACK_ENV'] = 'test'

require_relative '../app/application'

Dir[File.expand_path('../app/core/**/*.rb', __dir__)].each { |f| require f }

module RSpecMixin
  include Rack::Test::Methods
  def app
    Application.new
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include RSpecMixin
end
