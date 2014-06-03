require 'bikesched/filler'
require 'bikesched/unix_outputter'
require 'bikesched/version'
require 'bikesched/schedule'
require 'bikesched/schedule_database'

require 'time'
require 'English'

# A gateway to the URY radio schedule
module Bikesched
  # Outputs a schedule slice using the Unix output formatter.
  def self.print_slice_unix(slice)
    Bikesched::UnixOutputter.new.output_schedule_slice(slice)
  end

  def self.schedule
    sd = ScheduleDatabase.from_dbpasswd
    Schedule.new(sd)
  end

  def self.filler(*args)
    Filler.new(*args)
  end
end
