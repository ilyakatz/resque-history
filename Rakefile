require 'bundler'
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "resque-history"
    gem.summary = %Q{Show history of recently executed jobs}
    gem.description = %Q{Show history of recently executed jobs}
    gem.email = "ilyakatz@gmail.com"
    gem.homepage = "https://github.com/ilyakatz/resque-history"
    gem.authors = ["Katzmopolitan"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install   jeweler"
end