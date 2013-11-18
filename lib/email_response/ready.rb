require 'weeknote_submissions'
require 'weeknote_zipper'

class EmailResponse
  class Ready
    def parse(email, contributors)
      if email.subject.match(/end weeknotes/i)
        compile_weeknotes(email, contributors)
      else
        log_weeknotes(email, contributors)
      end
    end

    private
    def compile_weeknotes(email, contributors)
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
        :subject => email.subject,
        :body => email.body
      }

      # clear Tempfiles from this batch of submissions
      WeeknoteSubmissions.instance.clear!

      # TODO: also send a group email saying thanks
      [responses, WeeknoteState.new('idle'), contributors]
    end

    def log_weeknotes(email, contributors)
      contributors = contributors.submitted!(email.from.first)
      weeknote = WeeknoteSubmissions.instance.add email

      response = {
        :to => :all,
        :subject => "Weeknotes submission from #{weeknote[:from]}",
        :body => weeknote[:body],
        :attachments => weeknote[:attachments]
      }

      [[response], WeeknoteState.new('ready'), contributors]
    end
  end
end
