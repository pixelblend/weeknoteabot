require_relative '../spec_helper'
require 'weeknote'

describe Weeknote do
  describe "parsing" do
    it "parses simple mail objects" do
      mail = Mail.new do
        from 'Dan Nuttall <dan@bbc.co.uk>'
        subject 'My Subject'
        body 'My work this week'
      end

      subject = Weeknote.parse(mail)
      subject.name.must_equal 'Dan Nuttall'
      subject.email.must_equal 'dan@bbc.co.uk'
      subject.subject.must_equal 'My Subject'
      subject.body.must_equal 'My work this week'
      subject.attachments.must_equal []
    end

    it 'parses emails without a senders name' do
      mail = Mail.new do
        from 'dan@bbc.co.uk'
        subject 'My Subject'
        body 'My work this week'
      end

      subject = Weeknote.parse(mail)
      subject.name.must_equal ''
    end

    it 'parses emails without a subject' do
      mail = Mail.new do
        from 'dan@bbc.co.uk'
        body 'My work this week'
      end

      subject = Weeknote.parse(mail)
      subject.subject.must_equal '<No Subject>'
    end

    it 'parses empty emails' do
      mail = Mail.new do
        from 'dan@bbc.co.uk'
        subject 'My work this week'
      end

      subject = Weeknote.parse(mail)
      subject.body.must_equal ''
    end

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
