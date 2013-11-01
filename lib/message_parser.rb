require 'erb'

class MessageParser
  TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', 'templates')

  attr_reader :contributor, :email, :response, :state

  def initialize(state, contributor)
    @state = state
    @contributor = contributor
  end

  def parse(email)
    $logger.info "Processing state #{state.state}"
    sender = email.from.first

    case
    when !contributor.member?(sender)
      $logger.info "#{sender} not a known contributor"
      return false
    when !state.idle?
      $logger.info "#{state.state} state not processed yet"
      return false
    when email.subject.match(/new weeknotes/i)
      @response = { :to => :all, :subject => email.subject, :body => email.body }
      contributor.compiler = sender
      state.start!
    else
      @response = { :to => sender, :subject => 'Sorry, why did you send this?', :body => render('not_ready') }
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
