require 'mail'

module Mailer
  class DeliveryError < Exception; end
  FIND_ATTRIBUTES = {:what => :first, :order => :asc, :keys => ['NOT','SEEN']}

  def self.configure(email_config)
    Mail.defaults do
      retriever_method email_config[:receiving].delete(:method), email_config[:receiving]
      delivery_method  email_config[:sending].delete(:method), email_config[:sending]
    end
  end

  # find unread emails, oldest first
  def self.check_for_new_email(&blk)
    Mail.find(FIND_ATTRIBUTES) do |email, imap, uid|
      blk.call(email)

      # mark as read
      imap.uid_store( uid, "+FLAGS", [Net::IMAP::SEEN] )
    end
  end

  def self.send(email)
    email[:attachments] ||= []

    begin
      deliver(email)
    rescue ArgumentError => e
      raise DeliveryError, e
    end
  end

  private
  def self.deliver(email)
    Mail.deliver do
      from     email[:from]
      to       email[:to]
      subject  email[:subject]
      body     email[:body]

      email[:attachments].each do |attachment_path|
        add_file attachment_path
      end
    end
  end
end
