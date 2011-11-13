source 'http://rubygems.org'

gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '0-70-stable'

group :test do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'factory_girl_rails', '= 1.3.0'
  gem 'rcov'
  gem 'faker'
  gem 'shoulda', '>= 3.0.0.beta'
end

group :cucumber do
  gem 'sqlite3'
  gem 'cucumber-rails', '1.0.0'
  gem 'database_cleaner', '= 0.6.7'
  gem 'nokogiri'
  gem 'capybara', '1.0.1'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gemspec
