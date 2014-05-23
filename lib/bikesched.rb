require 'bikesched/unix_outputter'
require 'bikesched/version'
require 'bikesched/schedule'
require 'bikesched/schedule_database'

require 'time'
require 'English'

module Bikesched
  def self.schedule
    sd = ScheduleDatabase.from_dbpasswd
    Schedule.new(sd)
  end
end
