class WeeknoteSubmissions
  include Singleton

  def initialize
    @storage = []
  end

  def add(email)
    @storage << email
  end

  def count
    @storage.length
  end

  def clear!
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
