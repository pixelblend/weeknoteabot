require 'weeknote_state_cache'
require 'values'

class WeeknoteState < Value.new(:state)
  class InvalidStateError < Exception; end
  STATES = %w{idle ready}

  def initialize(*values)
    values = values.collect(&:downcase)
    super(*values)
    raise InvalidStateError, "#{@state} is not a valid state" unless STATES.include?(@state)
    WeeknoteStateCache.write(self)
  end
end
