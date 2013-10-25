require 'state_machine'

class Weeknote 
  state_machine :state, :initial => :idle do
    event :ready do
      transition :idle => :ready
    end
  end
end
