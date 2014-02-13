source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'bootstrap_form'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'figaro'

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
end