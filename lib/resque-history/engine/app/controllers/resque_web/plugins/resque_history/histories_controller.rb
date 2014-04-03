#require 'resque_web/app/controllers/resque_web/application_controller'

module ResqueWeb::Plugins::ResqueHistory
  #class HistoriesController < ActionController::Base
  class HistoriesController < ResqueWeb::ApplicationController
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
