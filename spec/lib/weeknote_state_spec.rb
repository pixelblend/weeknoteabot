require_relative '../spec_helper'
require 'weeknote_state'

describe WeeknoteState do
  subject { WeeknoteState.new }

  it "has initial state of idle" do
    subject.state.must_equal 'idle'
  end

  it "becomes ready on start" do
    subject.start!
    subject.state.must_equal "ready"
  end
end
