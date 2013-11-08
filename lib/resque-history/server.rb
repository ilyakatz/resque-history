require 'resque'
require 'resque/server'
require 'resque-history'

# Extends Resque Web Based UI.
# Structure has been borrowed from ResqueScheduler.
module ResqueHistory
  module Server
    include Resque::History::Helper

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

        post "/history/clear" do
          Resque.reset_history
          redirect u('history')
        end

      end
    end

    Resque::Server.tabs << 'History'
  end

  # Clears all historical jobs
  def reset_history
    size = Resque.redis.llen(Resque::Plugins::History::HISTORY_SET_NAME)

    size.times do
      Resque.redis.lpop(Resque::Plugins::History::HISTORY_SET_NAME)
    end

  end
end

Resque.extend ResqueHistory
Resque::Server.class_eval do
  include ResqueHistory::Server
end