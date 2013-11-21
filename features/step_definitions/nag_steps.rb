Given(/^a contributer has submitted$/) do
  weeknote = Weeknote.new('compiler', 'compiler@bbc.co.uk', 'weeknotes', 'Very busy this week')
  _, @state, @contributors = Responder.respond_to(weeknote, @state, @contributors)
end

When(/^the first nag period ends$/) do
  pending
end

Then(/^users who have not submitted are reminded to do so$/) do
  pending # express the regexp above with the code you wish you had
end
