require 'pstore'

class ContributorsCache
  def self.read
    # fetch from pstore (readonly)
    self.store.transaction(true) do
      self.store[:contributor]
    end
  end

  def self.write(contributor)
    # store in Pstore
    self.store.transaction do
      self.store[:contributor] = contributor
      self.store.commit
    end
  end

  private
  def self.store
    # true arg ensures thread-safe store
    @@store ||= PStore.new(self.location, true)
  end

  def self.location
    "db/contributors.pstore"
  end
end
