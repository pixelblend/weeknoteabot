require_relative '../../spec_helper'
require 'email_response/ready'

describe EmailResponse::Ready do
  subject { EmailResponse::Ready.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }
  let(:email) do
    Mail.new do
      from 'dan@bbc.co.uk'
      subject 'What I did this week'
      body 'Lots of stuff...'
    end
  end

  it 'relays messages to the rest of the contributors' do
    responses, state, new_contributors = subject.parse(email, contributors)

    responses.length.must_equal 1
    responses.first.must_equal({
      :to => :all, :subject => 'Weeknotes submission from dan@bbc.co.uk',
      :body => 'Lots of stuff...', :attachments => []
    })
    state.state.must_equal 'ready'
  end

  it 'marks the sender as a submitter to weeknotes' do
    responses, state, new_contributors = subject.parse(email, contributors)

    new_contributors.submitters.must_equal ['dan@bbc.co.uk']
  end

  it 'returns idle state when closing email is sent' do
    WeeknoteZipper.any_instance.expects(:zip!).once
    WeeknoteSubmissions.instance.expects(:compile!).returns({}).once
    Template.expects(:render).once
    email.stubs(:subject).returns('End weeknotes')

    response, state, new_contributors = subject.parse(email, contributors)

    state.state.must_equal 'idle'
  end

  it 'sends compiled emails when closing email is sent' do
    weeknotes = {
      :messages => [{
        :from => 'dan@bbc.co.uk', :body => 'I did loads!',
        :attachments => [{:name => 'file1.txt'}]
      }],
      :attachments => []
    }

    weeknote_zip = stub
    WeeknoteZipper.any_instance.stubs(:zip!).returns(weeknote_zip)
    WeeknoteSubmissions.instance.expects(:compile!).returns(weeknotes).once
    email.stubs(:subject).returns('End weeknotes')

    responses, state, new_contributors = subject.parse(email, contributors)

    responses.length.must_equal 1
    response = responses.first

    attachments = response[:attachments]

    attachments.length.must_equal 1
    attachments[0][:name].must_equal 'weeknotes.zip'
    attachments[0][:file].must_equal weeknote_zip

    response[:body].must_match 'dan@bbc.co.uk'
    response[:body].must_match 'file1.txt'
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
      responses, state, new_contributors = subject.parse(email, contributors)

      responses.first[:attachments].length.must_equal 1
    end
  end
end
