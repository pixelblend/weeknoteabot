require_relative '../../spec_helper'
require 'email_response/ready'

describe EmailResponse::Ready do
  subject { EmailResponse::Ready.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }
  let(:email) do
    stub(:email).tap do |e|
      e.stubs(:from).returns(['dan@bbc.co.uk'])
      e.stubs(:subject).returns('What I did this week')
      e.stubs(:body).returns('Lots of stuff...')
      e.stubs(:attachments).returns([])
    end
  end

  it 'relays messages to the rest of the contributors' do
    response, state, new_contributors = subject.parse(email, contributors)

    response.must_equal({
      :to => :all, :subject => 'Weeknotes submission from dan@bbc.co.uk',
      :body => 'Lots of stuff...', :attachments => []
    })
    state.state.must_equal 'ready'
  end

  it 'marks the sender as a submitter to weeknotes' do
    response, state, new_contributors = subject.parse(email, contributors)

    new_contributors.submitters.must_equal ['dan@bbc.co.uk']
  end

  it 'returns idle state when closing email is sent' do
    email.stubs(:subject).returns('End weeknotes')

    response, state, new_contributors = subject.parse(email, contributors)

    state.state.must_equal 'idle'
  end

  describe 'emails with attachments' do
    let(:attachment) do
      attachment = stub(:attachment).tap do |a|
        a.stubs(:filename)
        a.stubs(:read)
      end
    end

    it 'keeps attachments in relayed messages' do
      email.stubs(:attachments).returns([ attachment ])
      response, state, new_contributors = subject.parse(email, contributors)

      response[:attachments].length.must_equal 1
    end
  end
end
