Dir[File.dirname(__FILE__)+'/email_response/*.rb'].each { |f| require f }

class EmailResponse
  class GenerateError < Exception; end

  def generate(state)
    case state
    when 'idle'
      EmailResponse::Idle.new
    when 'ready'
      EmailResponse::Ready.new
    else
      raise GenerateError, "No response for state #{state}"
    end
  end
end
