require_relative '../spec_helper'
require 'mailer'
require 'tempfile'

describe Mailer do
  before do
    @email = {
      :from => 'dan@localhost',
      :to   => 'all@localhost',
      :subject => 'test email',
      :body => "hello there!"
    }
  end

  after do
    Mail::TestMailer.deliveries.clear
  end

  it 'fails without a recipient' do
    @email.delete(:to)
    proc { Mailer.send(@email) }.must_raise Mailer::DeliveryError
    Mail::TestMailer.deliveries.length.must_equal 0
  end

  it 'sends an email from a hash' do
    Mailer.send(@email)
    Mail::TestMailer.deliveries.length.must_equal 1

    sent = Mail::TestMailer.deliveries.first
    sent.from.must_equal ['dan@localhost']
    sent.to.must_equal ['all@localhost']
    sent.subject.must_equal 'test email'
    sent.body.to_s.must_equal 'hello there!'

    sent.attachments.must_be_empty
  end

  it 'sends plain text emails' do
    Mailer.send(@email)

    sent = Mail::TestMailer.deliveries.first
    all_plain_text = sent.parts.all? { |p| p.content_type =~ /text\/plain/ }
    all_plain_text.must_equal true
  end

  it 'attaches files to email' do
    file_to_be_attached = Tempfile.new('attachme')
    file_to_be_attached.write('attachment here')
    file_to_be_attached.rewind

    @email[:attachments] = [{:name => "filename.txt", :file => file_to_be_attached}]

    Mailer.send(@email)
    Mail::TestMailer.deliveries.length.must_equal 1

    sent = Mail::TestMailer.deliveries.first
    sent.attachments.length.must_equal 1

    file_to_be_attached.rewind

    attachment = sent.attachments.first
    attachment.filename.must_equal 'filename.txt'
    attachment.read.must_equal file_to_be_attached.read
  end
end
