require 'erb'

class MessageParser
  TEMPLATE_ROOT = File.join(File.dirname(__FILE__), '..', 'templates')

  attr_reader :email, :state, :response
  def initialize(email, state)
    @email = email
    @state = state
    @response = nil
  end

  def parse
    return false unless state.idle?

    if email.subject == 'WEEKNOTES BEGIN'
      @response = { :subject => email.subject, :body => email.body }
      state.ready!
    else
      @response = { :to => email.from, :subject => 'huh?', :body => render('not_ready') }
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
