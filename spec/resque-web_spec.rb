require 'spec_helper'

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
    job.perform
  end

  it "should respond to /history" do
    get '/history'
    last_response.should be_ok
  end

  it "should respond to remove history" do
    post "/history/clear"
    last_response.should be_redirect
  end

end

class HistoryJob
  extend Resque::Plugins::History
  @queue = :test

  def self.perform(*args)
  end
end