require_relative '../spec_helper'
require 'weeknote_period'

describe WeeknotePeriod do
  let(:thursday_morning)    { Time.mktime(2013,11,21, 11, 0) }
  let(:thursday_afternoon)  { Time.mktime(2013,11,21, 15, 0) }
  let(:friday_morning)      { Time.mktime(2013,11,22, 9, 0) }
  let(:friday_afternoon)    { Time.mktime(2013,11,22, 15, 21) }
  let(:saturday_night)      { Time.mktime(2013,11,23, 19, 55) }
  let(:sunday_morning)      { Time.mktime(2013,11,24, 10, 55) }
  let(:monday_morning)      { Time.mktime(2013,11,25, 9, 0) }

  it "is thursday afternoon given thursday morning" do
    subject = WeeknotePeriod.new(thursday_morning)
    next_period = subject.next

    (thursday_morning+next_period).must_equal thursday_afternoon
  end

  it "is friday morning given thursday afternoon" do
    subject = WeeknotePeriod.new(thursday_afternoon)
    next_period = subject.next

    (thursday_afternoon+next_period).must_equal friday_morning
  end

  it "is monday morning given friday afternoon" do
    subject = WeeknotePeriod.new(friday_afternoon)
    next_period = subject.next

    (friday_afternoon+next_period).must_equal monday_morning
  end

  it "is monday morning given saturday night" do
    subject = WeeknotePeriod.new(saturday_night)
    next_period = subject.next

    (saturday_night+next_period).must_equal monday_morning
  end

  it "is monday morning given sunday morning" do
    subject = WeeknotePeriod.new(sunday_morning)
    next_period = subject.next

    (sunday_morning+next_period).must_equal monday_morning
  end

  it "is thursday afternoon, then friday morning" do
    subject = WeeknotePeriod.new(thursday_morning)
    next_period = subject.next

    (thursday_morning+next_period).must_equal thursday_afternoon

    next_period = subject.next

    (thursday_afternoon+next_period).must_equal friday_morning
  end
end
