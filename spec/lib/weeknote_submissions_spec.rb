require_relative '../spec_helper'
require 'weeknote_submissions'
require 'weeknote'

describe WeeknoteSubmissions do
  subject { WeeknoteSubmissions.instance }
  let(:weeknote) { Weeknote.new 'dan', 'dan@bbc.co.uk', 'Subject', 'hello' }

  before do
    subject.clear!
  end

  it "collects weeknotes" do
    subject.add(weeknote)
    subject.count.must_equal 1
  end

  it "compiles weeknotes" do
    parsed = subject.add(weeknote)

    comp = subject.compile!
    comp[:messages].length.must_equal 1
    comp[:attachments].length.must_equal 0
  end

  describe "weeknotes with attachments" do
    let(:weeknote) do
      Weeknote.new 'dan', 'dan@bbc.co.uk', 'Subject', 'hello', [{:name => 'README.mdown', :file => Tempfile.new('README')}]
    end

    it 'flattens submitted attachments' do
      2.times { subject.add(weeknote) }
      subject.attachments.must_equal (weeknote.attachments * 2)
    end

    it 'empties weeknotes on clear' do
      subject.add(weeknote)
      subject.count.must_equal 1

      subject.clear!
      subject.count.must_equal 0
    end
  end
end
