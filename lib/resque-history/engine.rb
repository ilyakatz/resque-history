require 'resque_web'

module ResqueWeb::Plugins::ResqueHistory
  class Engine < Rails::Engine
    # isolate or not?
    isolate_namespace ResqueWeb::Plugins::ResqueHistory
    paths["app"] << 'lib/resque-history/engine/app'
    paths["app/helpers"] << 'lib/resque-history/engine/app/helpers'
    paths["app/views"] << 'lib/resque-history/engine/app/views'
    paths["app/controllers"] << 'lib/resque-history/engine/app/controllers'
  end
  Engine.routes do
    resource :history, only: [:show,:destroy]
  end
  def self.engine_path
    "/history"
  end
  def self.tabs
    [{'history' => Engine.app.url_helpers.history_path}]
  end
end
