require 'bikesched/filler'
require 'bikesched/unix_outputter'
require 'bikesched/version'
require 'bikesched/schedule'
require 'bikesched/schedule_database'

require 'time'
require 'English'

# A gateway to the URY radio schedule
module Bikesched
  def self.schedule
    sd = ScheduleDatabase.from_dbpasswd
    Schedule.new(sd)
  end

  def self.filler(*args)
    Filler.new(*args)
  end
end
