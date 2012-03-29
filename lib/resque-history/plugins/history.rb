module Resque
  module Plugins
    module History

      MAX_HISTORY_SIZE = 500
      HISTORY_SET_NAME = "resque_history"

      def maximum_history_size
        @max_hisory ||=MAX_HISTORY_SIZE
      end

      def after_perform_history(*args)

        Resque.redis.rpush(HISTORY_SET_NAME, {"class"=>self, "args"=>args}.to_json)

        if Resque.redis.llen(HISTORY_SET_NAME) > maximum_history_size
          Resque.redis.lpop(HISTORY_SET_NAME)
        end

      end

    end
  end
end
