require 'mail'
require 'weeknote'

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
    begin
      Mail.find(FIND_ATTRIBUTES) do |email, imap, uid|
        weeknote = Weeknote.parse(email)
        blk.call(weeknote)

        # mark as read
        imap.uid_store( uid, "+FLAGS", [Net::IMAP::SEEN] )
      end
    rescue EOFError => e
      $logger.error("CheckMailError: #{e}")
    end
  end

  def self.send(email)
    email[:attachments] ||= []

    begin
      $logger.info("Sending email")
      deliver(email)
    rescue ArgumentError => e
      raise DeliveryError, e
    end
  end

  private
  def self.deliver(email)
    Mail.deliver do
      charset = 'UTF-8'

      from     "Weeknoteabot <#{email[:from]}>"
      to       email[:to]
      subject  email[:subject]
      body     email[:body]

      email[:attachments].each do |attachment|
        begin
          add_file :filename => attachment[:name], :content => attachment[:file].read
        rescue => e
          $logger.warn("Could not attach file: #{e}")
        end
      end
    end
  end
end
