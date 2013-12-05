require 'pstore'

class WeeknoteStateCache
  def self.read
    # fetch from pstore (readonly)
    self.store.transaction(true) do
      self.store[:state]
    end
  end

  def self.write(state)
    # store in Pstore
    self.store.transaction do
      self.store[:state] = state
      self.store.commit
    end
  end

  private
  def self.store
    # true arg ensures thread-safe store
    @@store ||= PStore.new(self.location, true)
  end

  def self.location
    "db/state.pstore"
  end
end
