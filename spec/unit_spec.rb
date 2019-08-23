# frozen_string_literal: true
require 'json'
require 'rspec'
require 'rack/test'
require_relative '../stelligent'

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
  context 'get "/"' do
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Automation for the People" }
  end

  context 'returns the required JSON message' do
    it 'has a content type of JSON' do
      expect(response.headers["Content-Type"]).to include 'json'
    end
  end

  context 'timestamp' do
    it 'uses an integer timestamp format' do
      expect(JSON.parse(response.body)['timestamp']).to be_a(Integer)
    end
    it 'has the appropriate timestamp string length' do
      expect(JSON.parse(response.body)['timestamp'].to_s.length).to be 10
    end
  end
end
