source "http://rubygems.org"

# Specify your gem's dependencies in resque-history.gemspec
# gemspec

gem "resque", "~> 2.0.0.pre.1", github: "resque/resque"
gem 'resque-web', require: 'resque_web'

group :development, :test do
  gem "rake"
  gem "bundler"
  gem "jeweler"
  gem 'yajl-ruby'
end

group :test do
  gem "rspec-rails"
  gem "rspec", ">2.12.0"
  gem "rack-test"
  gem "timecop"
end
