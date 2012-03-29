# Resque Pause [![alt build status][1]][2]

[1]: https://secure.travis-ci.org/wandenberg/resque-pause.png
[2]: http://travis-ci.org/#!/wandenberg/resque-pause


A [Resque][rq] plugin. Requires Resque 1.9.10.

resque-pause adds functionality to pause resque jobs through the web interface.

Using a `pause` allows you to stop the job for a slice of time.
The job finish the process it are doing and don't get a new task to do,
until the queue is released.
You can use this functionality to do some maintenance whithout kill workers, for example.

Usage / Examples
----------------

### Single Job Instance

    require 'resque-pause'

    class UpdateNetworkGraph
      extend Resque::Plugins::Pause
      @queue = :network_graph

      def self.perform(repo_id)
        heavy_lifting
      end
    end

Pause is achieved by storing a pause/queue key in Redis.

Default behaviour...

* When the job instance try to execute and the queue is paused, the job is paused for a slice of time.
* If the queue still paused after this time the job will abort and will be enqueued again with the same arguments.


Resque-Web integration
----------------------

You have to load ResquePause to enable the Pause tab.

```ruby
    require 'resque-pause/server'
```

Customise & Extend
==================

### Job pause check interval

The slice of time the job will wait for queue be unpaused before abort the job
could be changed with attribute @pause_check_interval.

By default the time is 10 seconds.

You can define the attribute in your job class in seconds.

    class UpdateNetworkGraph
      extend Resque::Plugins::Pause
      @queue = :network_graph
      @pause_check_interval = 30

      def self.perform(repo_id)
        heavy_lifting
      end
    end

The above modification will ensure the job will wait for 30 seconds before abort.


Install
=======

    $ gem install resque-pause

[rq]: http://github.com/defunkt/resque
[resque-pause]: https://github.com/wandenberg/resque-pause
