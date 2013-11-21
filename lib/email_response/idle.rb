require 'weeknote_state'
require 'template'

class EmailResponse
  class Idle
    def parse(weeknote, contributors)
      responses = []

      if weeknote.subject.match(/begin weeknotes/i)
        responses << { :to => :all,
                       :subject => weeknote.subject,
                       :body => weeknote.body }
        state = WeeknoteState.new('ready')
        contributors = contributors.compiler! weeknote.email
      else
        body = Template.render('not_ready', :message => weeknote.body)
        responses << { :to => weeknote.email,
                       :subject => "RE: #{weeknote.subject}",
                       :body => body }
        state = WeeknoteState.new('idle')
      end

      [responses, state, contributors]
    end
  end
end
