# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rack', '< 3.0'

# EB still uses 2.16, not latest 3.x
# If you have any issues installing the Puma gem, it's probably because this ancient
# version uses an equally ancient OpenSSL by default...
group :deploy, :prod, :production do
  gem 'puma', '~> 2.16'
end

group :test, :dev, :development do
  gem 'rack-test'
  gem 'rspec'
  gem 'thin'
end
