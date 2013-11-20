require 'weeknote_state'
require 'weeknote_submissions'
require 'weeknote_zipper'
require 'template'

class EmailResponse
  class Ready
    def parse(weeknote, contributors)
      if weeknote.subject.match(/end weeknotes/i)
        compile_weeknotes(weeknote, contributors)
      else
        log_weeknotes(weeknote, contributors)
      end
    end

    private
    def compile_weeknotes(weeknote, contributors)
      responses = []

      weeknotes = WeeknoteSubmissions.instance.compile!
      zipped_attachments = WeeknoteZipper.new(weeknotes[:attachments]).zip!

      responses << {
        :to => contributors.compiler,
        :subject => 'Weeknotes compilation',
        :body => Template.render('compilation', :messages => weeknotes[:messages]),
        :attachments => [{:name => 'weeknotes.zip', :file => zipped_attachments}]
      }

      responses << {
        :to => :all,
        :subject => weeknote.subject,
        :body => weeknote.body
      }

      # clear Tempfiles from this batch of submissions
      WeeknoteSubmissions.instance.clear!

      # TODO: also send a group email saying thanks
      [responses, WeeknoteState.new('idle'), contributors]
    end

    def log_weeknotes(weeknote, contributors)
      contributors = contributors.submitted!(weeknote.email)
      WeeknoteSubmissions.instance.add weeknote

      response = {
        :to => :all,
        :subject => "Weeknotes submission from #{weeknote.sender}",
        :body => weeknote.body,
        :attachments => weeknote.attachments
      }

      [[response], WeeknoteState.new('ready'), contributors]
    end
  end
end
