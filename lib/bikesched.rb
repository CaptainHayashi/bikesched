require 'bikesched/unix_outputter'
require 'bikesched/version'
require 'bikesched/schedule'
require 'bikesched/schedule_database'

require 'time'
require 'English'

module Bikesched
  def self.database_schedule
    sd = ScheduleDatabase.from_dbpasswd
    Schedule.new(sd)
  end

  shows = self.database_schedule.from(Time.now).for(1).week
  UnixOutputter.new.output_schedule_slice(shows)
end
