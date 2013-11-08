require 'weeknote_submissions'

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
      raise NotImplementedError
    end

    def log_weeknotes(email, contributors)
      contributors = contributors.submitted!(email.from.first)
      weeknote = WeeknoteSubmissions.instance.add email

      response = {
        :to => :all,
        :subject => "Weeknotes submission from #{weeknote[:from]}",
        :body => weeknote[:body],
        :attachments => weeknote[:files]
      }

      [response, WeeknoteState.new('ready'), contributors]
    end
  end
end
