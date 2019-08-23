require 'rack'
require_relative 'stelligent'

if ['development', 'test'].include? ENV['RACK_ENV']
  handler = Rack::Handler::Thin
  port = 8888
else
  require 'rack/handler/puma'
  handler = Rack::Handler::Puma
  port = 8080
end

handler.run(StelligentMiniProject.new, Host: '0.0.0.0', Port: port)
