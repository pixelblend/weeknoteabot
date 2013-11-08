require_relative '../spec_helper'
require 'weeknote_state'

describe WeeknoteState do
  it "sets a state" do
    WeeknoteState.new('initial').state.must_equal 'initial'
  end
end
