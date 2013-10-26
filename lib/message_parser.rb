class MessageParser
  attr_reader :email, :state, :response
  def initialize(email, state)
    @email = email
    @state = state
    @response = nil
  end

  def parse
    ['read', email.subject, state.state, Time.now]
  end

  def ready?
    !response.nil?
  end
end
