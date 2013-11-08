require 'template'

class EmailResponse
  class NonContributor
    def parse(email)
      body = Template.render('non_contributor')
      response = {
        :to => email.from.first,
        :subject => "Sorry, you can't contribute",
        :body => body
      }
    end
  end
end
