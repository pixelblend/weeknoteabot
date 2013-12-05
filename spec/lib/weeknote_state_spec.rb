require_relative '../spec_helper'
require 'weeknote_state'

describe WeeknoteState do
  describe "valid states" do
    before(:each) do
      WeeknoteStateCache.expects(:write)
    end

    it "sets a state" do
      WeeknoteState.new('idle').state.must_equal 'idle'
    end

    it "downcases given states" do
      WeeknoteState.new('READY').state.must_equal 'ready'
    end
  end

  it "prevents invalid states" do
    -> { WeeknoteState.new('utah') }.must_raise \
      WeeknoteState::InvalidStateError
  end
end
