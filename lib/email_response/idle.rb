require 'weeknote_state'
require 'template'

class EmailResponse
  class Idle
    def parse(weeknote, contributors)
      responses = []

      if weeknote.subject.match(/begin weeknotes/i)
        responses << { :to => :all,
                       :subject => weeknote.subject,
                       :body => Template.render('started', :name => weeknote.name, :body => weeknote.body) }

        responses << { :to => weeknote.email,
                       :subject => %Q{You're compiling weeknotes!},
                       :body => Template.render('compiler') }

        state = WeeknoteState.new('ready')
        contributors = contributors.compiler! weeknote.email
      else
        body = Template.render('how_to', :message => weeknote.body)
        responses << { :to => weeknote.email,
                       :subject => "RE: #{weeknote.subject}",
                       :body => body }
        state = WeeknoteState.new('idle')
      end

      [responses, state, contributors]
    end
  end
end
