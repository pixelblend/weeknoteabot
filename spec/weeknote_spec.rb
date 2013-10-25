require_relative 'spec_helper'
require 'weeknote'

describe Weeknote do
  subject { Weeknote.new }

  it "has initial state of idle" do
    subject.state.must_equal 'idle'
  end

  it "becomes ready on start" do
    subject.start!
    subject.state.must_equal "ready"
  end
end
