require_relative '../../spec_helper'
require 'email_response/idle'
require 'contributors'

describe EmailResponse::Idle do
  subject { EmailResponse::Idle.new }

  it 'sends out new weeknotes notification and sets sender as the compiler' do
    email = stub(:email)
    email.expects(:from).returns(['dan@bbc.co.uk']).once
    email.expects(:subject).returns('New Weeknotes').at_least_once
    email.expects(:body).returns('Weeknotes please!').once

    contributors = Contributors.new(['dan@bbc.co.uk'])

    response, state, contributors = subject.parse(email, contributors)

    state.state.must_equal 'ready'
    response.must_equal({ :to => :all, :subject => 'New Weeknotes',
                          :body => 'Weeknotes please!' })
    contributors.compiler.must_equal 'dan@bbc.co.uk'
  end

  it 'replies to non-triggering email' do
    email = stub(:email)
    email.expects(:from).returns(['confused@bbc.co.uk']).once
    email.expects(:subject).returns('My work this week').once

    contributors = Contributors.new(['dan@bbc.co.uk'])

    response, state, contributors = subject.parse(email, contributors)

    response[:subject].must_equal 'Sorry, why did you send this?'
    response[:to].must_equal 'confused@bbc.co.uk'
    response[:body].must_match 'I don\'t understand'
    contributors.compiler.must_equal false
  end
end
