require_relative "spec_helper"
require "message_parser"

describe MessageParser do
  subject { MessageParser }

  it "accepts an email and a state" do
    parser = subject.new('email', 'state')
    parser.email.must_equal 'email'
    parser.state.must_equal 'state'
  end
end
