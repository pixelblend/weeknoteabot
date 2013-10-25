class MessageParser
  attr_reader :email, :state
  def initialize(email, state)
    @email = email
    @state = state
  end

  def parse
    p ['read', email.subject, state.state, Time.now]
    sleep(5)
  end
end
