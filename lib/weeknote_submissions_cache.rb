require 'pstore'

class WeeknoteSubmissionsCache
  def self.read
    # fetch from pstore (readonly)
    self.store.transaction(true) do
      self.store[:submissions]
    end
  end

  def self.write(submissions)
    # store in Pstore
    self.store.transaction do
      self.store[:submissions] = submissions
      self.store.commit
    end
  end

  private
  def self.store
    # true arg ensures thread-safe store
    @@store ||= PStore.new(self.location, true)
  end

  def self.location
    "db/submissions.pstore"
  end
end
