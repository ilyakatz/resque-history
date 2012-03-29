require 'resque'
require 'resque/server'

# Extends Resque Web Based UI.
# Structure has been borrowed from ResqueScheduler.
module ResqueHistory
  module Server
    include Resque::Helpers

    def self.erb_path(filename)
      File.join(File.dirname(__FILE__), 'server', 'views', filename)
    end

    def self.public_path(filename)
      File.join(File.dirname(__FILE__), 'server', 'public', filename)
    end

    def self.included(base)

      base.class_eval do

        get '/history' do
          erb File.read(ResqueHistory::Server.erb_path('history.erb'))
        end

      end
    end

    Resque::Server.tabs << 'History'
  end
end

Resque.extend ResqueHistory
Resque::Server.class_eval do
  include ResqueHistory::Server
end
