require 'mail'

module Mailer
  def self.send(email)
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
