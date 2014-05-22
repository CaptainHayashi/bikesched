require 'bikesched/version'
require 'bikesched/schedule_database'

require 'time'
require 'English'

module Bikesched
  sd = ScheduleDatabase.from_dbpasswd

  shows = sd.range(Time.now, Time.now + (60 * 60 * 24)).all
  show_ids = shows.map { |show| show[:show_id] }
  show_names = sd.show_names(show_ids, Time.now)

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
          escape(show_names[show[:show_id]]))
  end
end
