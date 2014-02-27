module ResqueWeb::Plugins::ResqueHistory
  module HistoriesHelper
    def format_execution(seconds)
      if seconds.nil?
        ""
      elsif seconds < 60
        "#{seconds} secs"
      elsif seconds < 60 * 60
        "#{(seconds/60).to_i} minutes"
      elsif seconds < 60 * 60 * 24
        "#{(((seconds.to_f/60/60)*100).truncate.to_f)/100} hours"
      elsif seconds < 60 * 60 * 24 * 7
        "#{(((seconds.to_f/60/60/24)*100).truncate.to_f)/100} days"
      else
        "too long"
      end
    end

    def resque_history_total_jobs
      Resque.redis.llen(Resque::Plugins::History::HISTORY_SET_NAME)
    end

    def show_args(args)
      Array(args).map do |a|
        a.to_yaml
      end.join("\n")
    end
  end
end
