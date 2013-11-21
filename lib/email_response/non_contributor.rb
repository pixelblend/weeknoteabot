require 'template'

class EmailResponse
  class NonContributor
    def parse(weeknote)
      body = Template.render('non_contributor')
      response = [{
        :to => weeknote.email,
        :subject => "Sorry, you can't contribute",
        :body => body
      }]
    end
  end
end
