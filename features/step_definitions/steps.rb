$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'mail'

require 'weeknote_state'
require 'message_parser'

Before do
  @state = WeeknoteState.new
end

Given(/^a state of (.*)$/) do |state|
  @state.state.must_equal state
end

When(/^an email is recieved$/) do
  @email = Mail.new
end

When(/^the sender is a (contributor|stranger)$/) do |sender_type|
  case sender_type
  when 'contributor'
    @email.from = 'known@bbc.co.uk'
  else
    pending
  end 
end

When(/^the subject is (.*)$/) do |subject|
  @email.subject = subject 
end

When(/^the email is parsed$/) do
  @parser = MessageParser.new(@email, @state)
  @parser.parse
  @response = @parser.response
end

Then(/^the state should be (.*)$/) do |state|
  @state.state.must_equal state 
end

Then(/^the response should be sent to the (group|sender|compiler)$/) do |recipient|
  case recipient
  when 'sender'
    @response[:to].must_equal @email.from
  when 'group'
    @response[:to].must_equal :all
  else
    pending
  end
end

Then(/^the subject should be (.*)$/) do |subject|
  @response[:subject].must_equal subject
end

