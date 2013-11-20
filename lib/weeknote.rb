require 'values'
require 'tempfile'

class Weeknote < Value.new(:name, :email, :subject, :body, :attachments)
  def self.parse(mail)
    unless mail[:from].nil?
      name = mail[:from].display_names.first || ''
      from = mail.from.first
    end

    body = parse_body(mail)

    subject = mail.subject
    attachments = parse_attachments(mail.attachments)

    new(name, from, subject, body, attachments)
  end

  def initialize(name, email, subject, body, attachments=[])
    name ||= ''
    body ||= ''
    subject ||= '<No Subject>'

    super(name, email, subject, body, attachments)
  end

  private
  def self.parse_body(mail)
    body = mail.body.decoded

    return body unless body.blank?

    bodies = {}

    mail.parts.each do |p|
      next if p.attachment?
      bodies[p.content_type] = p.decoded
    end

    case
    when bodies.has_key?('text/plain')
      bodies['text/plain']
    when bodies.has_key?('text/html')
      # naive scrubbing of html tags
      bodies['text/html'].gsub(%r{</?[^>]+?>}, '')
    when bodies.values.length > 0
      # whatever it is, let's use it
      bodies.values.first
    else
      String.new
    end
  end

  def self.parse_attachments(attachments)
    attachments.collect do |f|
      tmpfile = Tempfile.new('weeknote_attachment')
      tmpfile.write(f.read)

      { :name => f.filename, :file => tmpfile }
    end
  end
end
