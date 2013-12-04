require 'weeknote_state'
require 'weeknote_submissions'
require 'weeknote_zipper'
require 'template'

class EmailResponse
  class Ready
    def parse(weeknote, contributors)
      if weeknote.subject.match(/end weeknotes/i)
        if contributors.compiler?(weeknote.email)
          compile_weeknotes(weeknote, contributors)
        else
          youre_not_the_compiler(weeknote, contributors)
        end
      else
        log_weeknotes(weeknote, contributors)
      end
    end

    private
    def compile_weeknotes(weeknote, contributors)
      responses = []

      weeknotes = WeeknoteSubmissions.instance.compile!
      body = Template.render('compilation', :messages => weeknotes[:messages])

      transcript_file = Tempfile.new('transcript')
      transcript_file.write(body)

      weeknotes[:attachments] << {:name => 'transcript.txt', :file => transcript_file}
      zipped_attachments = WeeknoteZipper.new(weeknotes[:attachments]).zip!

      responses << {
        :to => contributors.compiler,
        :subject => 'Weeknotes compilation',
        :body => body,
        :attachments => [{:name => 'weeknotes.zip', :file => zipped_attachments}]
      }

      responses << {
        :to => :all,
        :subject => 'Weeknotes are done!',
        :body => weeknote.body
      }

      # clear this batch of submissions
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
        :body => Template.render('submission', :name => weeknote.name, :body => weeknote.body),
        :attachments => weeknote.attachments
      }

      [[response], WeeknoteState.new('ready'), contributors]
    end

    def youre_not_the_compiler(weeknote, contributors)
      response = {
        :to => weeknote.email,
        :subject => "You can't finish weeknotes...",
        :body => Template.render('cant_finish_weeknotes', :compiler => contributors.compiler),
      }

      [[response], WeeknoteState.new('ready'), contributors]
    end
  end
end
