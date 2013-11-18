$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'mail'

require 'weeknote_state'
require 'contributors'
require 'responder'

Before do
  @contributors = Contributors.new(['known@bbc.co.uk'])
end

Given(/^weeknotes have been started$/) do
  @state = WeeknoteState.new('ready')
end

Given(/^weeknotes haven't been started$/) do
  @state = WeeknoteState.new('idle')
end

When(/^a (contributor|stranger) sends an email$/) do |sender_type|
  @email = Mail.new

  case sender_type
  when 'contributor'
    @email.from = 'known@bbc.co.uk'
  else
    @email.from = 'unknown@itv.com'
  end
end

When(/^the subject is "(.*)"$/) do |subject|
  @email.subject = subject
end

When(/^the email has an attachment$/) do
  @email.attachments << Tempfile.new('weeknote_attachment')
end

Then(/^weeknotes will( not)? be started$/) do |started|
  @responses, @state, @contributors = Responder.respond_to(@email, @state, @contributors)

  if started =~ /not/
    @state.state.must_equal 'idle'
  else
    @state.state.must_equal 'ready'
  end
end

Then(/^that contributor becomes the compiler$/) do
  @contributors.compiler?('known@bbc.co.uk').must_equal true
end

Then(/^(everyone|the contributor|the stranger) will receive an email.*$/) do |whom|
  case whom
  when 'everyone'
    @responses.first[:to].must_equal :all
  when 'the contributor'
    @responses.first[:to].must_equal 'known@bbc.co.uk'
  when 'the stranger'
    @responses.first[:to].must_equal 'unknown@itv.com'
  end
end

Then(/^the subject will be "(.*)"$/) do |subject|
  @responses.first[:subject].must_equal subject
end

Then(/^the contents of the email are saved for later$/) do
  @responses, @state, @contributors = Responder.respond_to(@email, @state, @contributors)
  WeeknoteSubmissions.instance.count.must_equal 1
end

Then(/^it is noted that the contributor has submitted weeknotes$/) do
  @contributors.submitted?('known@bbc.co.uk').must_equal true
end

Then(/^everyone will receive the email$/) do
  @responses.first[:to].must_equal :all
  @responses.first[:subject].must_equal "Weeknotes submission from known@bbc.co.uk"
  @responses.first[:body].must_equal @email.body
end

