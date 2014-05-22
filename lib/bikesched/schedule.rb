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
    def time_range(start_time, end_time)
      timeslots = @source.range(start_time, end_time).all
      show_ids = timeslots.map { |show| show[:show_id] }
      show_names = @source.show_names(show_ids, Time.now)

      timeslots.map do |show|
        show.merge(show_name: show_names[show[:show_id]])
      end
    end
  end
end
