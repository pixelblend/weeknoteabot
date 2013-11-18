require 'tempfile'

class WeeknoteSubmissions
  include Singleton

  def initialize
    @storage = []
  end

  def add(email)
    msg = {
      :from => email[:from].value,
      :body => email.body.to_s,
      :attachments => parse_files(email.attachments)
    }

    @storage << msg
    msg
  end

  def count
    @storage.length
  end

  def clear!
    # unlink temp files
    @storage.each do |s|
      s.fetch(:attachments, []).each do |f|
        f[:file].close
        f[:file].unlink
      end
    end

    initialize
  end

  def compile!
    compiled = {
      :messages => @storage,
      :attachments => attachments
    }

    compiled
  end

  def attachments
    @storage.map do |s|
      s[:attachments]
    end.flatten
  end

  private
  def parse_files(files)
    files.collect do |f|
      tmpfile = Tempfile.new('weeknote_attachment')
      tmpfile.write(f.read)

      { :name => f.filename, :file => tmpfile }
    end
  end
end
