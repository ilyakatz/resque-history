module Resque
  module Plugins
    module History

      MAX_HISTORY_SIZE = 500
      HISTORY_SET_NAME = "resque_history"

      def maximum_history_size
        @max_history ||= MAX_HISTORY_SIZE
      end

      def on_failure_history(exception, *args)
        Resque.redis.lpush(HISTORY_SET_NAME, {"class"=>"#{self}",
                                              "time"=>Time.now.strftime("%Y-%m-%d %H:%M"),
                                              "args"=>args,
                                              "error"=>exception.message
        }.to_json)

        if Resque.redis.llen(HISTORY_SET_NAME) > maximum_history_size
          Resque.redis.rpop(HISTORY_SET_NAME)
        end

      end


      def before_perform_hsitory(*args)
        @start_time = Time.now
      end

      def after_perform_history(*args)
        elapsed_seconds = (Time.now - @start_time).to_i
        Resque.redis.lpush(HISTORY_SET_NAME, {"class"=>"#{self}",
                                              "args"=>args,
                                              "time"=>Time.now.strftime("%Y-%m-%d %H:%M"),
                                              "execution"=>elapsed_seconds
        }.to_json)

        if Resque.redis.llen(HISTORY_SET_NAME) > maximum_history_size
          Resque.redis.rpop(HISTORY_SET_NAME)
        end

      end

    end
  end
end