# frozen_string_literal: true

require 'sinatra/base'
require 'dotenv'
Dotenv.load

# Application class
class Application < Sinatra::Base
  get '/' do
    'Ruby Insurance API'
  end
end
