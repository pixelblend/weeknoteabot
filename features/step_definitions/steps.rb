$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'weeknote'

Before do
  @weeknote = Weeknote.new
end

Given(/^a state of (.*)$/) do |state|
  @weeknote.state.to_s.must_equal state
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

