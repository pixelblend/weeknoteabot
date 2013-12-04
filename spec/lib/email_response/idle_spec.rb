require_relative '../../spec_helper'
require 'email_response/idle'
require 'contributors'
require 'weeknote'

describe EmailResponse::Idle do
  subject { EmailResponse::Idle.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }

  it 'sends out new weeknotes notification confirms sender as the compiler' do
    email = Weeknote.new('dan', 'dan@bbc.co.uk', 'Begin Weeknotes', 'Send me your notes')

    responses, state, new_contributors = subject.parse(email, contributors)

    new_contributors.compiler.must_equal 'dan@bbc.co.uk'

    state.state.must_equal 'ready'

    responses.length.must_equal 2
    responses[0][:to].must_equal :all
    responses[0][:subject].must_equal 'Weeknotes please!'
    responses[0][:body].must_include 'Send me your notes'
    responses[1][:to].must_equal 'dan@bbc.co.uk'
    responses[1][:subject].must_equal "You're compiling weeknotes!"
  end

  it 'replies to non-triggering email' do
    email = Weeknote.new('dan', 'dan@bbc.co.uk', 'My work this week', 'hello')

    responses, state, new_contributors = subject.parse(email, contributors)

    responses.length.must_equal 1
    response = responses.first

    response[:subject].must_equal 'RE: My work this week'
    response[:to].must_equal 'dan@bbc.co.uk'
    response[:body].must_match "Here's how weeknotes works:"
    new_contributors.compiler.must_equal false
  end
end
