require 'weeknote_state'
require 'template'

class EmailResponse
  class Idle
    def parse(weeknote, contributors)
      if weeknote.subject.match(/begin weeknotes/i)
        response = { :to => :all,
                     :subject => weeknote.subject,
                     :body => weeknote.body }
        state = WeeknoteState.new('ready')
        contributors = contributors.compiler! weeknote.email
      else
        body = Template.render('not_ready', :message => weeknote.body)
        response = { :to => weeknote.email,
                     :subject => "RE: #{weeknote.subject}",
                     :body => body }
        state = WeeknoteState.new('idle')
      end

      [[response], state, contributors]
    end
  end
end
