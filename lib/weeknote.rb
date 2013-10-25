require 'state_machine'

class Weeknote 
  state_machine :state, :initial => :idle do
    event :start do
      transition :idle => :ready
    end
  end
end
