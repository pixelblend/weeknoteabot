require_relative '../spec_helper'
require 'weeknote'

describe Weeknote do
  describe "parsing" do
    it "parses simple mail objects"
    it "parses multipart email"
    it "parses attachments"
  end

  describe "attributes" do
    let(:attachments) { [stub] }
    subject { Weeknote.new 'Dan Nuttall', 'dan@bbc.co.uk', 'My work',
              'I worked hard', attachments }

    it "has the name of the sender" do
      subject.name.must_equal 'Dan Nuttall'
    end

    it "has an email address" do
      subject.email.must_equal 'dan@bbc.co.uk'
    end

    it "has a subject" do
      subject.subject.must_equal 'My work'
    end

    it "has a body" do
      subject.body.must_equal 'I worked hard'
    end

    it "has attachments" do
      subject.attachments.must_equal attachments
    end
  end
end
