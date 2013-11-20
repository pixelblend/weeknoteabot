require_relative '../../spec_helper'
require 'email_response/idle'
require 'contributors'
require 'weeknote'

describe EmailResponse::Idle do
  subject { EmailResponse::Idle.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }

  it 'sends out new weeknotes notification and sets sender as the compiler' do
    email = Weeknote.new('dan', 'dan@bbc.co.uk', 'Begin Weeknotes', 'Weeknotes please!')

    responses, state, new_contributors = subject.parse(email, contributors)

    state.state.must_equal 'ready'

    responses.length.must_equal 1
    responses.first.must_equal({ :to => :all, :subject => 'Begin Weeknotes',
                          :body => 'Weeknotes please!' })
    new_contributors.compiler.must_equal 'dan@bbc.co.uk'
  end

  it 'replies to non-triggering email' do
    email = Weeknote.new('dan', 'dan@bbc.co.uk', 'My work this week', 'hello')

    responses, state, new_contributors = subject.parse(email, contributors)

    responses.length.must_equal 1
    response = responses.first

    response[:subject].must_equal 'RE: My work this week'
    response[:to].must_equal 'dan@bbc.co.uk'
    response[:body].must_match 'I don\'t understand'
    new_contributors.compiler.must_equal false
  end
end
