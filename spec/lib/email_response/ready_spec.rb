require_relative '../../spec_helper'
require 'email_response/ready'
require 'contributors'
require 'weeknote'

describe EmailResponse::Ready do
  subject { EmailResponse::Ready.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }
  let(:weeknote) do
    Weeknote.new 'Dan', 'dan@bbc.co.uk', 'What I did this week', 'Lots of stuff...', [{:name => 'file1.txt'}]
  end

  it 'relays messages to the rest of the contributors' do
    responses, state, new_contributors = subject.parse(weeknote, contributors)

    responses.length.must_equal 1
    responses.first.must_equal({
      :to => :all, :subject => 'Weeknotes submission from Dan <dan@bbc.co.uk>',
      :body => 'Lots of stuff...', :attachments => [{:name => 'file1.txt'}]
    })
    state.state.must_equal 'ready'
  end

  it 'marks the sender as a submitter to weeknotes' do
    responses, state, new_contributors = subject.parse(weeknote, contributors)

    new_contributors.submitters.must_equal ['dan@bbc.co.uk']
  end

  it 'returns idle state when closing weeknote is sent' do
    WeeknoteZipper.any_instance.expects(:zip!).once
    WeeknoteSubmissions.instance.expects(:compile!).returns({}).once
    Template.expects(:render).once

    weeknote = Weeknote.new('Dan', 'dan@bbc.co.uk', 'End Weeknotes', '')

    response, state, new_contributors = subject.parse(weeknote, contributors)

    state.state.must_equal 'idle'
  end

  it 'sends compiled weeknotes when closing weeknote is sent' do
    weeknote_zip = stub
    WeeknoteZipper.any_instance.stubs(:zip!).returns(weeknote_zip)
    WeeknoteSubmissions.instance.add weeknote

    ending_weeknote = Weeknote.new('dan', 'dan@bbc.co.uk', 'End weeknotes', '')

    responses, state, new_contributors = subject.parse(ending_weeknote, contributors)

    responses.length.must_equal 2

    compiled = responses.first

    attachments = compiled[:attachments]

    attachments.length.must_equal 1
    attachments[0][:name].must_equal 'weeknotes.zip'
    attachments[0][:file].must_equal weeknote_zip

    compiled[:body].must_match 'Dan'
    compiled[:body].must_match 'dan@bbc.co.uk'
    compiled[:body].must_match 'file1.txt'

    notification = responses.last
    notification[:to].must_equal :all
    notification[:subject].must_equal 'End weeknotes'
  end

  describe 'weeknotes with attachments' do
    it 'keeps attachments in relayed messages' do
      responses, state, new_contributors = subject.parse(weeknote, contributors)

      responses.first[:attachments].length.must_equal 1
    end
  end
end
