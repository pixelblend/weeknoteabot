require_relative "spec_helper"
require "message_parser"

describe MessageParser do
  subject { MessageParser }

  it "accepts an email and a state" do
    parser = subject.new('email', 'state')
    parser.email.must_equal 'email'
    parser.state.must_equal 'state'
  end

  describe "#ready" do
    subject { MessageParser.new('email', 'state') }

    it 'is not ready if there is no response set' do
      subject.response.must_be_nil
      subject.ready?.must_equal false
    end

    it 'is ready when a response has been set' do
      subject.stub :response, {:to => "dan@bbc"} do
        subject.ready?.must_equal true
      end
    end
  end
end
