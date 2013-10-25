$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'weeknote_state'

Before do
  @weeknote = WeeknoteState.new
end

Given(/^a state of (.*)$/) do |state|
  @weeknote.state.must_equal state
end

When(/^an email is recieved$/) do
  pending 
end

When(/^the sender is a (contributor|stranger)$/) do |sender_type|
  pending 
end

When(/^the subject is (.*)$/) do |subject|
  pending 
end

Then(/^the state should be (.*)$/) do |state|
  pending 
end

Then(/^the email should be sent to the (group|contributor)$/) do |recipient|
  pending 
end

