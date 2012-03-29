Changelog
=========

### 0.0.4

* improvement on job reserve to prevent fork worker when queue is paused
* bug fix for the gem work with resque-restriction gem, and other which re-implements job reserve method
* changing the require for load resque-web integration to

```ruby
    require 'resque-pause/server'
```

### 0.0.3

* bug fix on re-enqueue the job
* improvement on resque-web integration urls

### 0.0.2

* updating documentation
* generating a good package for rubygems

### 0.0.1

* version was removed from rubygems, bad package
