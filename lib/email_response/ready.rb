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
      weeknotes = WeeknoteSubmissions.instance.compile!
      zipped_attachments = WeeknoteZipper.new(weeknotes[:attachments]).zip!

      response = {
        :to => contributors.compiler,
        :subject => 'Weeknotes compilation',
        :body => 'Hello, here are the weeknotes',
        :attachments => zipped_attachments
      }

      # also send a group email saying thanks

      [response, WeeknoteState.new('idle'), contributors]
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

      [response, WeeknoteState.new('ready'), contributors]
    end
  end
end
