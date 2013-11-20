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
      mail = Mail.new

      subject = Weeknote.parse(mail)
      subject.body.must_equal ''
    end

    it "uses plain text body if available" do
      mail = Mail.new do
        text_part do
          body 'This is plain text'
        end

        html_part do
          body '<h1>This is HTML</h1>'
        end
      end

      subject = Weeknote.parse(mail)
      subject.body.must_equal 'This is plain text'
    end

    it "uses decoded HTML email if plain text is not available" do
      mail = Mail.new do
        subject 'HTML only'

        content_type 'text/html; charset=UTF-8'
        html_part do
          body '<h1>This is HTML</h1>'
        end
      end

      subject = Weeknote.parse(mail)
      subject.body.must_equal 'This is HTML'
    end

    it "parses attachments" do
      mail = Mail.new do
        subject "attachments"
        body "hello there"
        add_file File.join(File.dirname(__FILE__)+'/../../README.mdown')
      end

      subject = Weeknote.parse(mail)
      subject.body.must_equal "hello there"

      subject.attachments.length.must_equal 1

      attached = subject.attachments.first
      attached[:name].must_equal 'README.mdown'
      attached[:file].must_be_instance_of File
    end
  end

  describe "sender" do
    it "uses the email address if that is the only information" do
      weeknote = Weeknote.with(:name => nil, :email => 'dan@bbc.co.uk', :subject => nil, :body => nil)
      weeknote.sender.must_equal 'dan@bbc.co.uk'
    end

    it "uses the name if that is the only information" do
      weeknote = Weeknote.with(:name => 'Dan', :email => nil, :subject => nil, :body => nil)
      weeknote.sender.must_equal 'Dan'
    end

    it "uses the email and name combined" do
      weeknote = Weeknote.with(:name => 'Dan', :email => 'dan@bbc.co.uk', :subject => nil, :body => nil)
      weeknote.sender.must_equal 'Dan <dan@bbc.co.uk>'
    end
  end
  describe "attributes" do
    let(:attachments) { [stub] }
    subject { Weeknote.new 'Dan Nuttall', 'DAN@bbc.co.uk', 'My work',
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
