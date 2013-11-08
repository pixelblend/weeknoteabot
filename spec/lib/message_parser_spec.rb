require_relative "../spec_helper"
require "message_parser"

describe MessageParser do
end
__END__
  subject { MessageParser }

  it "accepts a state and a contributor list" do
    parser = subject.new('state', [])
    parser.state.must_equal 'state'
    parser.contributor.must_equal []
  end

  describe "when status is ready" do
    before do
      @email = mock('mail')

      @contributor = mock('contributor')

      @state = mock('state', :state => 'idle')
      @state.expects(:idle?).returns(true)

      @parser = subject.new(@state, @contributor)
    end

    it 'replies to non-triggering email in a confused manner' do
      @email.expects(:subject).returns('My work this week').at_least_once
      @email.expects(:from).returns(['confused@bbc.co.uk']).at_least_once
      @state.expects(:start!).never

      @contributor.expects(:member?).with('confused@bbc.co.uk').returns(true)

      @parser.parse(@email)

      @parser.reply?.must_equal true
      response = @parser.response

      response[:subject].must_equal 'Sorry, why did you send this?'
      response[:to].must_equal 'confused@bbc.co.uk'
      response[:body].must_match 'I don\'t understand'
    end

    it 'sends out triggering email and sets ready state' do
      @email.expects(:from).returns(['dan@bbc.co.uk'])
      @email.expects(:subject).returns('New Weeknotes').at_least_once
      @email.expects(:body).returns('Weeknotes please!').at_least_once

      @contributor.expects(:member?).with('dan@bbc.co.uk').returns(true)
      @contributor.expects(:compiler=).with('dan@bbc.co.uk').returns(true)

      @state.expects(:start!)

      @parser.parse(@email)
      @parser.reply?.must_equal true

      @parser.response[:to].must_equal :all
      @parser.response[:subject].must_equal 'New Weeknotes'
      @parser.response[:body].must_equal 'Weeknotes please!'
    end
  end

  describe "#reply?" do
    subject { MessageParser.new('state', []) }

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
