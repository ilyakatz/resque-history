require 'spec_helper'
require 'timecop'


describe ResqueHistory::Server do
  include Rack::Test::Methods

  def app
    @app ||= Resque::Server.new
  end

  let :queues do
    Resque.redis.sadd(:queues, "queue1")
    Resque.redis.sadd(:queues, "queue2")
    Resque.redis.sadd(:queues, "queue3")
  end

  before do
    queues
    Resque.enqueue(HistoryJob, 12)
    job = Resque.reserve('test')
    Timecop.freeze(2008, 10, 5, 10, 12) do
      job.perform
    end
  end

  it "should respond to /history" do
    get '/history'
    last_response.should be_ok
    last_response.body.should include("HistoryJob")
    last_response.body.should include("0 secs")
    last_response.body.should include("2008-10-05 10:12")
  end

  it "should respond to remove history" do
    get '/history'
    last_response.body.should include("HistoryJob")
    post "/history/clear"
    last_response.should be_redirect
    get '/history'
    last_response.body.should_not include("HistoryJob")
  end

end

class HistoryJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(*args)
  end
end