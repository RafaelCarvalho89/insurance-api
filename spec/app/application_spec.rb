# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application do
  describe 'GET /' do
    context 'when the request is successful' do
      it 'returns a 200 status code' do
        get '/'
        expect(last_response.status).to eq(200)
        expect(last_response.body).to eq('Ruby Insurance API')
      end
    end

    context 'when the request is unsuccessful' do
      it 'returns a 500 status code' do
        allow_any_instance_of(Application).to receive(:response).and_raise(StandardError)
        get '/'
        expect(last_response.status).to eq(500)
      end
    end
  end

  describe 'METHOD /missing_resource' do
    it 'returns a 404 status code' do
      %w[get post put delete].each do |method|
        send(method, '/missing_resource')
        expect(last_response.status).to eq(404)
      end
    end
  end
end
