require_relative 'email_response'

module Responder
  def self.respond_to(weeknote, state, contributors)
    if contributors.member?(weeknote.email)
      email_parser = EmailResponse.new.generate(state.state)
      reply, state, contributors = email_parser.parse(weeknote, contributors)
    else
      reply = EmailResponse::NonContributor.new.parse(weeknote)
    end

    [reply, state, contributors]
  end
end
