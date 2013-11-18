require_relative '../../spec_helper'
require 'email_response/idle'
require 'contributors'

describe EmailResponse::Idle do
  subject { EmailResponse::Idle.new }
  let(:contributors) { Contributors.new(['dan@bbc.co.uk']) }
  let(:email) do
    stub(:email).tap do |e|
      e.stubs(:from).returns(['dan@bbc.co.uk'])
      e.stubs(:body).returns('Weeknotes please!')
    end
  end

  it 'sends out new weeknotes notification and sets sender as the compiler' do
    email.expects(:subject).returns('Begin Weeknotes').twice

    responses, state, new_contributors = subject.parse(email, contributors)

    state.state.must_equal 'ready'

    responses.length.must_equal 1
    responses.first.must_equal({ :to => :all, :subject => 'Begin Weeknotes',
                          :body => 'Weeknotes please!' })
    new_contributors.compiler.must_equal 'dan@bbc.co.uk'
  end

  it 'replies to non-triggering email' do
    email.expects(:subject).returns('My work this week').once

    responses, state, new_contributors = subject.parse(email, contributors)

    responses.length.must_equal 1
    response = responses.first

    response[:subject].must_equal 'Sorry, why did you send this?'
    response[:to].must_equal 'dan@bbc.co.uk'
    response[:body].must_match 'I don\'t understand'
    new_contributors.compiler.must_equal false
  end
end
