$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'mail'

require 'weeknote_state'
require 'message_parser'
require 'contributor'

Before do
  @state = WeeknoteState.new
  @contributor = Contributor.new

  @contributor.stubs(:request).returns([
    {'email' => 'known@bbc.co.uk'}
  ])
end

Given(/^weeknotes haven't been started$/) do
  @state.state.must_equal 'idle'
end

When(/^a (contributor|stranger) sends an email$/) do |sender_type|
  @email = Mail.new

  case sender_type
  when 'contributor'
    @email.from = 'known@bbc.co.uk'
  else
    pending
  end
end

When(/^the subject is "(.*)"$/) do |subject|
  @email.subject = subject
end

Then(/^weeknotes will( not)? be started$/) do |started|
  @parser = MessageParser.new(@state, @contributor)
  @parser.parse(@email)
  @response = @parser.response

  if started =~ /not/
    @state.state.must_equal 'idle'
  else
    @state.state.must_equal 'ready'
  end
end

Then(/^that contributor becomes the compiler$/) do
  @contributor.compiler?('known@bbc.co.uk').must_equal true
end

Then(/^(everyone|the contributor) will receive an email.*$/) do |whom|
  case whom
  when 'everyone'
    @response[:to].must_equal :all
  when 'the contributor'
    @response[:to].must_equal @email.from.first
  end
end

Then(/^the subject will be "(.*)"$/) do |subject|
  @response[:subject].must_equal subject
end

