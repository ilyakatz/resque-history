require 'spec_helper'
require 'timecop'

class HistoryJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(*args)
  end
end

class MaxHistoryJob
  extend Resque::Plugins::History
  @queue = :test2
  @max_history = 15

  def self.perform(*args)
  end
end


describe Resque::Plugins::History do
  it "should be compliance with Resqu::Plugin document" do
    expect { Resque::Plugin.lint(Resque::Plugins::History) }.to_not raise_error
  end

  it "should store history of the job" do
    Timecop.freeze(Time.local(2000, 9, 1, 12, 0, 0)) do
      Resque.enqueue(HistoryJob, 12)

      job = Resque.reserve('test')
      job.perform

      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      arr.count.should == 1
      JSON.parse(arr.first).should == {"class"=>"HistoryJob", "args"=>[12], "time"=>"2000-09-01 12:00"}
    end
  end

  it "should use the max_history size of the history list" do
    MaxHistoryJob.maximum_history_size.should == 15
  end


  it "should set the default size of the history list to be 500" do
    HistoryJob.maximum_history_size.should == 500
  end

  it "should truncate the maximum" do

    HistoryJob.stub(:maximum_history_size).and_return { 3 }

    Resque.enqueue(HistoryJob, 15)
    Resque.enqueue(HistoryJob, 13)
    Resque.enqueue(HistoryJob, 12)
    Resque.enqueue(HistoryJob, 11)

    Timecop.freeze(Time.local(2000, 9, 1, 12, 0, 0)) do
      job = Resque.reserve('test')
      job.perform
      job = Resque.reserve('test')
      job.perform
      job = Resque.reserve('test')
      job.perform
      job = Resque.reserve('test')
      job.perform

      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      arr.count.should == 3
      arr.should == [
          {"class"=>"HistoryJob", "args"=>[13], "time"=>"2000-09-01 12:00"},
          {"class"=>"HistoryJob", "args"=>[12], "time"=>"2000-09-01 12:00"},
          {"class"=>"HistoryJob", "args"=>[11], "time"=>"2000-09-01 12:00"}
      ].collect(&:to_json)
    end

  end

end
