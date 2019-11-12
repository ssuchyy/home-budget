source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.11'
gem 'pg'

# Authentication/Authorization
gem 'devise'
gem 'doorkeeper'

# API
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-rails'

# Service
gem 'dry-monads'
gem 'dry-struct'
gem 'dry-types'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'pry', '~> 0.12.2'
  gem 'pry-rails'
  gem 'letter_opener'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'shoulda-matchers'
end
