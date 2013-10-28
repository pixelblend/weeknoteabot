require 'erb'

class MessageParser
  TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', 'templates')

  attr_reader :email, :state, :response

  def initialize(state)
    @state = state
  end

  def parse(email)
    $logger.info "Processing state #{state.state}"
    # check sender is in group
    return false unless state.idle?

    if email.subject.match(/new weeknotes/i)
      @response = { :to => :all, :subject => email.subject, :body => email.body }
      state.start!
    else
      @response = { :to => email.from, :subject => 'Sorry, why did you send this?', :body => render('not_ready') }
    end
  end

  def reply?
    !response.nil?
  end

  private

  def render(template_name)
    template_file = File.join(TEMPLATE_ROOT, template_name+'.erb')
    template = File.read(template_file)

    ERB.new(template).result(binding)
  end
end
