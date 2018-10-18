source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap',    '>= 1.1.0', require: false
gem 'country_select'
gem 'devise'
gem 'jbuilder',    '~> 2.5'
gem 'pg',          '>= 0.18', '< 2.0'
gem 'puma',        '~> 3.11'
gem 'rails',       '~> 5.2.1'
gem 'redis',       '~> 4.0'
gem 'sass-rails',  '~> 5.0'
gem 'simple_form', '~> 4.0'
gem 'tag_columns', '~> 0.1.6'
gem 'turbolinks',  '~> 5'
gem 'uglifier',    '>= 1.3.0'
gem 'webpacker',   '~> 3.5'

group :development, :test do
  gem 'awesome_print'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'annotate'
  gem 'listen',                '>= 3.0.5', '< 3.2'
  gem 'model_probe'
  #gem 'spring'
  #gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console',           '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
