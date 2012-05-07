module Resque
  module History
    module Helper

      def self.format_execution(seconds)
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

    end
  end

end