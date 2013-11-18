class WeeknotePeriod
  TWENTY_FOUR_HOURS = (60*60*24)

  def self.next
    now = Time.now
    next_period(now) - now
  end

  private
  def self.next_period(now)
    case now.hour
    when 0..12
      period = next_afternoon(now)
    else
      period = next_morning(now)
    end

    if on_a_weekday?(period)
      period
    else
      next_period(period)
    end
  end

  def self.next_morning(now)
    next_day = now + TWENTY_FOUR_HOURS
    Time.mktime(next_day.year, next_day.month, next_day.day, 9, 0)
  end

  def self.next_afternoon(now)
    Time.mktime(now.year, now.month, now.day, 15, 0)
  end

  def self.on_a_weekday?(now)
    !(now.saturday? || now.sunday?)
  end
end
