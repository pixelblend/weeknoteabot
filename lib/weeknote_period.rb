class WeeknotePeriod
  TWENTY_FOUR_HOURS = (60*60*24)

  def initialize(start)
    @periods = [start]
  end

  def next
    @periods << next_period
    @periods[-1] - @periods[-2]
  end

  def last_period
    @periods.last
  end

  private
  def next_period(time=last_period)
    case time.hour
    when 0..12
      period = next_afternoon(time)
    else
      period = next_morning(time)
    end

    if on_a_weekday?(period)
      period
    else
      next_period(period)
    end
  end

  def next_morning(time)
    next_day = time + TWENTY_FOUR_HOURS
    Time.mktime(next_day.year, next_day.month, next_day.day, 9, 0)
  end

  def next_afternoon(time)
    Time.mktime(time.year, time.month, time.day, 15, 0)
  end

  def on_a_weekday?(time)
    !(time.saturday? || time.sunday?)
  end
end
