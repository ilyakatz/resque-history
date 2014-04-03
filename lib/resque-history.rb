require 'resque'
require 'resque-history/engine'
#require 'resque-history/engine/app/controllers/resque_web/plugins/resque_history/histories_controller'
require File.expand_path(File.join('resque-history', 'plugins', 'history'), File.dirname(__FILE__))
require File.expand_path(File.join('resque-history', 'helpers', 'helper'), File.dirname(__FILE__))
