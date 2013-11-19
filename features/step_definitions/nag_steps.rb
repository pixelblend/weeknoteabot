Given(/^a contributer has submitted$/) do
  weeknote = Mail.new do
    from 'compiler@bbc.co.uk'
    subject 'weeknotes'
    body 'Very busy this week'
  end

  _, @state, @contributors = Responder.respond_to(weeknote, @state, @contributors)
end

When(/^the first nag period ends$/) do
  WeeknotePeriod.next
  pending
end

Then(/^users who have not submitted are reminded to do so$/) do
  pending # express the regexp above with the code you wish you had
end
