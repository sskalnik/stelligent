# frozen_string_literal: true
require 'rspec'
require 'rack/test'
require_relative '../stelligent'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

describe StelligentMiniProject do
  let(:app) { StelligentMiniProject.new }
  let(:response) { get '/' }

  context 'get "/"' do
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Automation for the People" }
  end

  context "returns the JSON message" do
    it 'has a content type of JSON' do
      expect(response.headers["Content-Type"]).to include 'json'
    end
  end
end
