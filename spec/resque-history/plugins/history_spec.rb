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
      expected = {
        "class" => "HistoryJob", "args" => [12],
        "time" => "2000-09-01 12:00:00 +0000", "execution" => 0
      }
      expect(JSON.parse(arr.first)).to eq(expected)
    end
  end

  it "should use the max_history size of the history list" do
    expect(MaxHistoryJob.maximum_history_size).to eq 15
  end

  it "should set the default size of the history list to be 500" do
    HistoryJob.maximum_history_size.should == 500
  end

  it "should truncate the maximum" do

    expect(HistoryJob).to receive(:maximum_history_size).at_least(:once).and_return(3)

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

      JSON.parse(arr[0]).should == {"class"=>"HistoryJob", "args"=>[11], "time"=>"2000-09-01 12:00:00 +0000", "execution"=>0}
      JSON.parse(arr[1]).should == {"class"=>"HistoryJob", "args"=>[12], "time"=>"2000-09-01 12:00:00 +0000", "execution"=>0}
      JSON.parse(arr[2]).should == {"class"=>"HistoryJob", "args"=>[13], "time"=>"2000-09-01 12:00:00 +0000", "execution"=>0}

    end

  end

  it "should allow to remove history" do

    Resque.enqueue(HistoryJob, 15)
    Resque.enqueue(HistoryJob, 13)

    job = Resque.reserve('test')
    job.perform
    job = Resque.reserve('test')
    job.perform

    arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

    arr.count.should == 2

    Resque.reset_history

    arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

    arr.count.should == 0

  end

  describe "record execution time" do

    it "should record execution time" do

      Resque.enqueue(SlowHistoryJob, 10)

      Timecop.freeze(Time.local(2000, 9, 1, 12, 0, 0)) do
        job = Resque.reserve('test')
        job.perform
      end

      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      arr.count.should == 1
      JSON.parse(arr[0]).should == {"class"=>"SlowHistoryJob", "args"=>[10], "time"=>"2000-09-01 12:10:00 +0000", "execution"=>600}

    end

    it "should not confuse different job times" do

      Resque.enqueue(SlowHistoryJob, 10)
      Resque.enqueue(SlowHistoryJob, 5)

      Timecop.freeze(Time.local(2000, 9, 1, 12, 0, 0)) do
        job = Resque.reserve('test')
        job.perform

        job = Resque.reserve('test')
        job.perform

      end

      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      arr.count.should == 2

      JSON.parse(arr[0]).should == {"class"=>"SlowHistoryJob", "args"=>[5], "time"=>"2000-09-01 12:15:00 +0000", "execution"=>300}
      JSON.parse(arr[1]).should == {"class"=>"SlowHistoryJob", "args"=>[10], "time"=>"2000-09-01 12:10:00 +0000", "execution"=>600}

    end

    it "should record times in the order of completion not in order of starting" do

      #start the longer job first but it should finish last
      Resque.enqueue(SleepyHistoryJob, 3)
      Resque.enqueue(SleepyHistoryJob, 1)

      job = Resque.reserve('test')
      job.perform

      job = Resque.reserve('test')
      job.perform

      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      JSON.parse(arr.first)["class"].should =="SleepyHistoryJob"
      JSON.parse(arr.first)["args"].should ==[1]
      JSON.parse(arr.first)["execution"].should ==1

      JSON.parse(arr.last)["class"].should =="SleepyHistoryJob"
      JSON.parse(arr.last)["args"].should ==[3]
      JSON.parse(arr.last)["execution"].should ==3

    end

    it "should record failed jobs" do

      Resque.enqueue(ExceptionJob,"nothing")

      job = Resque.reserve('test')

      lambda { job.perform }.should raise_exception
      arr = Resque.redis.lrange(Resque::Plugins::History::HISTORY_SET_NAME, 0, -1)

      arr.count.should == 1

      JSON.parse(arr.first)["class"].should =="ExceptionJob"
      JSON.parse(arr.first)["args"].should == ["nothing"]
      JSON.parse(arr.first)["execution"].should == nil
      JSON.parse(arr.first)["error"].should == "I'm an error"
    end

  end

end

class SlowHistoryJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(time_in_minutes)
    Timecop.travel(Time.now + 60*time_in_minutes)
  end
end

class SleepyHistoryJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(time_in_seconds)
    sleep(time_in_seconds)
  end
end

class ExceptionJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(arg)
    raise StandardError, "I'm an error"
  end
end
