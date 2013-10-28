require_relative "spec_helper"
require "message_parser"

describe MessageParser do
  subject { MessageParser }

  it "accepts an email and a state" do
    parser = subject.new('email', 'state')
    parser.email.must_equal 'email'
    parser.state.must_equal 'state'
  end

  describe "when status is ready" do
    before do
      @email = mock('mail')

      @state = mock('state')
      @state.expects(:idle?).returns(true)

      @parser = subject.new(@email, @state)
    end

    it 'replies to non-triggering email in a confused manner' do
      @email.expects(:subject).returns('My work this week').at_least_once
      @email.expects(:from).returns('confused@bbc.co.uk').at_least_once
      @state.expects(:start!).never

      @parser.parse
      
      @parser.reply?.must_equal true
      response = @parser.response

      response[:subject].must_equal 'Sorry, why did you send this?'
      response[:to].must_equal 'confused@bbc.co.uk'
      response[:body].must_match 'I don\'t understand'
    end

    it 'sends out triggering email and sets ready state' do
      @email.expects(:subject).returns('New Weeknotes').at_least_once
      @email.expects(:body).returns('Weeknotes please!').at_least_once

      @state.expects(:start!)

      @parser.parse
      @parser.reply?.must_equal true

      @parser.response[:to].must_equal :all
      @parser.response[:subject].must_equal 'New Weeknotes'
      @parser.response[:body].must_equal 'Weeknotes please!'
    end
  end

  describe "#reply?" do
    subject { MessageParser.new('email', 'state') }

    it 'no reply if there is no response set' do
      subject.response.must_be_nil
      subject.reply?.must_equal false
    end

    it 'is a reply when a response has been set' do
      subject.stub :response, {:to => "dan@bbc"} do
        subject.reply?.must_equal true
      end
    end
  end
end
