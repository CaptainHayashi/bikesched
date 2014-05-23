module Bikesched
  # A schedule gateway
  #
  # This extends a schedule data source (such as a database) to provide
  # a more flexible interface.
  class Schedule
    def initialize(source)
      @source = source
    end

    # Finds the schedule slice between two Times
    def time_range(from_time, to_time)
      fail('To time before from time.') if to_time < from_time
      @source.range(from_time, to_time)
    end

    def from(time)
      ScheduleFrom.new(self, time)
    end
  end

  class ScheduleFrom
    def initialize(schedule, from_time)
      @schedule  = schedule
      @from_time = from_time
    end

    def to(to_time)
      fail('To time before from time.') if to_time < @from_time
      @schedule.time_range(@from_time, to_time)
    end

    def for_seconds(duration)
      to(@from_time + duration)
    end

    def for(duration)
      fail('Negative duration.') if duration < 0
      ScheduleFor.new(self, duration)
    end
  end

  class ScheduleFor
    def initialize(schedule_from, duration)
      @schedule_from = schedule_from
      @duration      = duration
    end

    { second: 1,
      minute: 60,
      hour:   60 * 60,
      day:    60 * 60 * 24,
      week:   60 * 60 * 24 * 7
    }.each do |name, in_seconds|
      define_method(name) { @schedule_from.for_seconds(@duration * in_seconds) }
      alias_method "#{name}s".to_sym, name
    end
  end
end
