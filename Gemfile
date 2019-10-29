source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'pg'

# API
gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'pry', '~> 0.12.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end
