require 'values'
class Weeknote < Value.new(:name, :email, :subject, :body, :attachments)
  def self.parse(mail)
    name = mail[:from].display_names.first || ''
    from = mail.from.first
    subject = mail.subject || '<No Subject>'
    body = mail.body.to_s

    new(name, from, subject, body)
  end

  def initialize(name, email, subject, body, attachments=[])
    name ||= ''
    subject ||= '<No Subject>'

    super(name, email, subject, body, attachments)
  end
end
