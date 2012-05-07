require 'spec_helper'

describe Resque::History::Helper do

  it "should show correct number of seconds" do
    Resque::History::Helper.format_execution(40).should == "40 secs"
  end

  it "should show correct number of minutes" do
    Resque::History::Helper.format_execution(600).should == "10 minutes"
    Resque::History::Helper.format_execution(659).should == "10 minutes"
    Resque::History::Helper.format_execution(660).should == "11 minutes"
  end

  it "should show correct number of hours" do
    Resque::History::Helper.format_execution(3600).should == "1.0 hours"
    Resque::History::Helper.format_execution(7200).should == "2.0 hours"
    Resque::History::Helper.format_execution(5400).should == "1.5 hours"
    Resque::History::Helper.format_execution(5403).should == "1.5 hours"
    Resque::History::Helper.format_execution(5703).should == "1.58 hours"
  end

  it "should show correct number of days" do
    Resque::History::Helper.format_execution(86400).should == "1.0 days"
    Resque::History::Helper.format_execution(129600).should == "1.5 days"
    Resque::History::Helper.format_execution(518400).should == "6.0 days"
  end

  it "should show that job is too long" do
    Resque::History::Helper.format_execution(604800).should == "too long"
  end

end