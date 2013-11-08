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
    skip('Waiting for compilation class')
    email.stubs(:subject).returns('End weeknotes')

    response, state, new_contributors = subject.parse(email, contributors)

    state.state.must_equal 'idle'

    response.must_equal({
      :to => 'dan@bbc.co.uk'
    })
  end

  describe 'emails with attachments' do
    let(:attachment) do
      attachment = stub(:attachment).tap do |a|
        a.stubs(:content_type)
        a.stubs(:filename)
        a.stubs(:read)
      end
      #email.stubs(:attachments).returns([ attachment ])
    end

    it 'keeps attachments in relayed messages' do
      skip('figure out attachments')
      Weeknotes.stubs(:add).with(email).returns(attachments)

      response, state, new_contributors = subject.parse(email, contributors)

      response.must_equal({
        :to => :all, :subject => 'What I did this week', :body => 'Lots of stuff...'
      })
      state.state.must_equal 'ready'
    end

    it 'saves emails out for compilation later'
  end
end
