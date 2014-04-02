require 'resque_web'

module ResqueWeb
  module Plugins
    module ResqueHistory
      class HistoriesController
        def show

        end

        def destroy
          reset_history
          redirect_to :show
        end

        private

        def reset_history
          size = redis.llen(Resque::Plugins::History::HISTORY_SET_NAME)

          size.times do
            redis.lpop(Resque::Plugins::History::HISTORY_SET_NAME)
          end

        end
      end
    end
  end
end

