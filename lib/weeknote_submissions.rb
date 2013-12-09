require 'weeknote_submissions_cache'

class WeeknoteSubmissions
  include Singleton

  def initialize
    @storage = WeeknoteSubmissionsCache.read || []
  end

  def add(email)
    @storage << email
    WeeknoteSubmissionsCache.write(@storage)

    @storage
  end

  def count
    @storage.length
  end

  def clear!
    WeeknoteSubmissionsCache.write([])
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
    @storage.collect(&:attachments).flatten
  end
end
