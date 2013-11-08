require_relative '../spec_helper'
require 'email_response'

describe EmailResponse do
  subject { EmailResponse.new }

  it 'returns parsable object in response to state' do
    response = subject.generate('idle')
    response.must_respond_to :parse
  end

  it 'raises when no state is found' do
    lambda { subject.generate('nope') }.must_raise EmailResponse::GenerateError
  end
end
