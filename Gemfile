# frozen_string_literal: true

source "https://rubygems.org"

gem "dry-types", "~> 1.0", ">= 1.6.1"
gem "hanami", "~> 2.0"
gem "hanami-controller", "~> 2.0"
gem "hanami-router", "~> 2.0"
gem "hanami-validations", "~> 2.0"
gem "puma"
gem "rake"
gem 'rubocop', require: false
gem 'rubocop-rake', require: false

group :development, :test do
  gem "dotenv"
  gem "rspec_junit_formatter", require: false
end

group :cli, :development do
  gem "hanami-reloader"
end

group :cli, :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "hanami-rspec"
end

group :development do
  gem "guard-puma", "~> 0.8"
end

group :test do
  gem "rack-test"
end
