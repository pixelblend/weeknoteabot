require_relative 'email_response'

module Responder
  def self.respond_to(email, state, contributors)
    if contributors.member?(email.from.first)
      email_parser = EmailResponse.new.generate(state.state)
      reply, state, contributors = email_parser.parse(email, contributors)
    else
      reply = EmailResponse::NonContributor.new.parse(email)
    end

    [reply, state, contributors]
  end
end
