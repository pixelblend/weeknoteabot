require 'statemachine'
module Weeknote
  def self.new
    Statemachine.build do
      trans :idle, :begin, :ready
    end
  end
end
