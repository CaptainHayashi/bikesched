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

  $OFS = ':'
  $ORS = "\n"

  def self.escape(string)
    string.gsub(/([#{$OFS}#{$ORS}])/, '\\\\\1')
  end

  shows.each do |show|
    print(show[:show_id],
          show[:show_season_id],
          show[:show_season_timeslot_id],
          show[:start_time].to_i,
          show[:end_time].to_i,
          escape(show[:show_name]))
  end
end
