$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'weeknote'

require 'weeknote_state'
require 'contributors'
require 'responder'

Before do
  WeeknoteSubmissions.instance.clear!
  @contributors = Contributors.new(['known@bbc.co.uk', 'compiler@bbc.co.uk'])
end

Given(/^weeknotes have been started$/) do
  @state = WeeknoteState.new('ready')
end

Given(/^weeknotes haven't been started$/) do
  @state = WeeknoteState.new('idle')
end

Given(/^weeknotes emails have been submitted$/) do
  weeknotes = []
  weeknotes << Weeknote.new('Compiler', 'compiler@bbc.co.uk',
    'weeknotes', 'Very busy this week')

  weeknotes << Weeknote.new('Known Person', 'known@bbc.co.uk',
    'my weeknotes', 'I did some stuff')

  weeknotes.each do |weeknote|
    _, @state, @contributors = Responder.respond_to(weeknote, @state, @contributors)
  end

  @contributors.submitters.count.must_equal 2
  WeeknoteSubmissions.instance.count.must_equal 2
end

When(/^a (compiler|contributor|stranger) sends an email$/) do |sender_type|
  case sender_type
  when 'contributor'
    @email = 'known@bbc.co.uk'
  when 'compiler'
    @contributors = @contributors.compiler! 'compiler@bbc.co.uk'
    @email = 'compiler@bbc.co.uk'
  when 'stranger'
    @email = 'unknown@itv.com'
  end
end

When(/^the subject is "(.*)"$/) do |subject|
  @weeknote = Weeknote.new(nil, @email, subject, nil)
end

When(/^the email has an attachment$/) do
  values = @weeknote.values
  values.last << Tempfile.new('weeknote_attachment')
  @weeknote = Weeknote.new(*values)
end

Then(/^weeknotes will( not)? be started$/) do |started|
  @responses, @state, @contributors = Responder.respond_to(@weeknote, @state, @contributors)

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
  @responses, @state, @contributors = Responder.respond_to(@weeknote, @state, @contributors)
  WeeknoteSubmissions.instance.count.must_equal 1
end

Then(/^it is noted that the contributor has submitted weeknotes$/) do
  @contributors.submitted?('known@bbc.co.uk').must_equal true
end

Then(/^everyone will receive the email$/) do
  @responses.first[:to].must_equal :all
  @responses.first[:subject].must_equal "Weeknotes submission from known@bbc.co.uk"
  @responses.first[:body].must_equal @weeknote.body
end

Then(/^the compiled weeknotes will be sent to the compiler$/) do
  @responses, @state, @contributors = Responder.respond_to(@weeknote, @state, @contributors)
  @responses.first[:to].must_equal 'compiler@bbc.co.uk'
  @responses.first[:subject].must_equal 'Weeknotes compilation'
end

Then(/^the contributors are told that weeknotes are finished$/) do
  @state.state.must_equal "idle"

  @responses.length.must_equal 2
  response = @responses[1]
  response[:to].must_equal :all
  response[:subject].must_equal 'Weeknotes are done!'
  response[:body].must_equal @weeknote.body
end
