require 'weeknote_state'
require 'template'

class EmailResponse
  class Idle
    def parse(email, contributors)
      sender = email.from.first

      if email.subject.match(/begin weeknotes/i)
        response = { :to => :all,
                     :subject => email.subject,
                     :body => email.body }
        state = WeeknoteState.new('ready')
        contributors = contributors.compiler! sender
      else
        body = Template.render('not_ready')
        response = { :to => sender,
                     :subject => 'Sorry, why did you send this?',
                     :body => body }
        state = WeeknoteState.new('idle')
      end

      [[response], state, contributors]
    end
  end
end
