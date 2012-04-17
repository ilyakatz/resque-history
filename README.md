# Resque History [![alt build status][1]][2]

[1]: https://secure.travis-ci.org/ilyakatz/resque-history.png?branch=master
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

Resque-Web integration
----------------------

You have to load ResqueHistory to enable the History tab.

```ruby
    require 'resque-history/server'
```

Install
=======

    $ gem install resque-pause
    
Add to routes.rb file

    require 'resque-history/server'

[rq]: http://github.com/defunkt/resque