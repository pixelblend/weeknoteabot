require 'tempfile'

class WeeknoteSubmissions
  include Singleton

  def initialize
    @storage = []
  end

  def add(email)
    msg = {
      :from => email.from.first,
      :body => email.body.to_s,
      :files => parse_files(email.attachments)
    }

    @storage << msg
    msg
  end

  def clear!
    # unlink temp files
    @storage.each do |s|
      s.fetch(:files, []).each do |f|
        f[:file].close
        f[:file].unlink
      end
    end

    initialize
  end

  def compilation
    @storage
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
