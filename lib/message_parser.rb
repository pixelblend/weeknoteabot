class MessageParser
  attr_reader :email, :state
  def initialize(email, state)
    @email = email
    @state = state
  end

  def parse
    ['read', email.subject, state.state, Time.now]
  end

  def respond
    ['respond', email.subject, Time.now]
  end
end
