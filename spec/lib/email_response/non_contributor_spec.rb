require_relative '../../spec_helper'
require 'email_response/non_contributor'

describe EmailResponse::NonContributor do
  subject { EmailResponse::NonContributor.new }
  it 'replies explaining why the email cannot be processed' do
    email = stub(:email)
    email.expects(:from).returns(['someone@internet.com'])

    response = subject.parse(email)
    response[:to].must_equal 'someone@internet.com'
    response[:subject].must_equal "Sorry, you can't contribute"
    response[:body].must_include 'not on our contributor list'
  end
end
