require_relative '../spec_helper'
require 'nag_email'

describe NagEmail do
  it "addresses an email to contributors that haven't submitted" do
    email = NagEmail.new(['dan@bbc.co.uk']).write
    email[:to].must_equal ['dan@bbc.co.uk']
  end

  it "doesn't write an email if everyone has submitted" do
    email = NagEmail.new([]).write
    email.must_equal nil
  end

  it "uses nagging language" do
    email = NagEmail.new(['dan@bbc.co.uk']).write
    email[:subject].must_equal 'Please write your weeknotes'
    email[:body].must_include "haven't written your weeknotes"
  end
end
