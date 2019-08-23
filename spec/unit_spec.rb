# frozen_string_literal: true
require 'json'
require 'rspec'
require 'rack/test'
require_relative '../stelligent'
require 'thin' if ENV['RACK_ENV'] != 'development'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.fail_if_no_examples = true
  # Show verbose per-test output instead of just ".....F....F.."
  config.formatter = 'documentation'
end

describe StelligentMiniProject do
  let(:app) { StelligentMiniProject.new }
  let(:response) { get '/' }

  # Intentionally use two different approaches to formatting `it...expect` statements just to show what's possible
  context 'when getting "/"' do
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Automation for the People" }
  end

  context 'when getting "/some_invalid_path/"' do
    let(:response) { get '/some_invalid_path/' }
    it { expect(response.status).not_to eq  200 }
    it { expect(response.status.to_s).to match /4\d\d/ }
    it { expect(response.status).to eq 404 }
  end

  context 'when in development or test' do
    it 'runs on port 8888' do
      server = Thin::Server.new('0.0.0.0', '8888', app)
      expect(server.port.to_i).to eq 8888
    end
  end

  context 'when in deploy or production' do
    it 'runs on port 8080' do
      server = Thin::Server.new('0.0.0.0', '8080', app)
      expect(server.port.to_i).to eq 8080
    end
  end

  context 'when returning the required JSON message' do
    it 'has a content type of JSON' do
      expect(response.headers["Content-Type"]).to include 'json'
    end
    it 'uses an integer timestamp format' do
      expect(JSON.parse(response.body)['timestamp']).to be_a(Integer)
    end
    it 'has the appropriate timestamp string length' do
      expect(JSON.parse(response.body)['timestamp'].to_s.length).to be 10
    end
  end
end
