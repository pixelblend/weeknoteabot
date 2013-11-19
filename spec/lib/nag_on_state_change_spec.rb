require_relative '../spec_helper'
require 'nag_on_state_change'
require 'weeknote_state'

describe NagOnStateChange do
  it "starts nag thread when state moves from idle to ready" do
    subject = NagOnStateChange.new([], WeeknoteState.new('idle'))
    subject.expects(:start_nag_thread).once
    subject.expects(:stop_nag_thread).never

    subject.state = WeeknoteState.new('ready')
  end

  it "removes nag thread when state moves from ready from idle" do
    subject = NagOnStateChange.new([], WeeknoteState.new('ready'))
    subject.expects(:start_nag_thread).never
    subject.expects(:stop_nag_thread).once

    subject.state = WeeknoteState.new('idle')
  end

  it "doesn't respond when state remains the same" do
    subject = NagOnStateChange.new([], WeeknoteState.new('idle'))
    subject.expects(:start_nag_thread).never
    subject.expects(:stop_nag_thread).never

    subject.state = WeeknoteState.new('idle')
  end
end
