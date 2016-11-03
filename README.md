# Resque History
[![alt build status][1]][2]
[![Dependency Status](http://img.shields.io/gemnasium/ilyakatz/he.svg)](https://gemnasium.com/ilyakatz/resque-history)
[![Code Climate](http://img.shields.io/codeclimate/github/ilyakatz/resque-history.svg)](https://codeclimate.com/github/ilyakatz/resque-history)
[![Gem Version](http://img.shields.io/gem/v/resque-history.svg)](http://badge.fury.io/rb/resque-history)

[1]: http://img.shields.io/travis/ilyakatz/resque-history.svg
[2]: http://travis-ci.org/#!/ilyakatz/resque-history


A [Resque][rq] plugin. Requires Resque

resque-history adds functionality record recently history of job executions

Usage / Examples
----------------

### Single Job Instance

```ruby
    require 'resque-history'

    class UpdateNetworkGraph
      extend Resque::Plugins::History
      @queue = :network_graph

      def self.perform(some_id)
        do_stuff(some_id)
      end
    end
```


### Job History

By default resque-history stores 500 history items on redis,
but if you want to store less items, assign @max_history in the job class.

```ruby
    require 'resque-history'

    class UpdateNetworkGraph
      extend Resque::Plugins::History
      @queue = :network_graph
      @max_history = 50 # max number of histories to be kept

      def self.perform(some_id)
        do_stuff(some_id)
      end
    end
```

### 3rd Party classes

If you want to use resque history with 3rd party resque jobs,
extended the classes that you want to be recorded in history

```ruby
[
    CarrierWave::Workers::ProcessAsset,
    CarrierWave::Workers::StoreAsset,
    ActionMailer::DeliveryMethods
].each do |klazz|
  klazz.class_eval do
    extend Resque::Plugins::History
  end
end
```

Resque-Web integration
----------------------

'History' tab in resque web GUI

![Resque History GUI](https://monosnap.com/file/0FNT1ZINLWlRS0in5JPxYVKjCa3v84.png)


Install
=======

Add to your Gemfile

    $ gem "resque-history"

Add to routes.rb file

    require 'resque-history/server'

[rq]: https://github.com/resque/resque
