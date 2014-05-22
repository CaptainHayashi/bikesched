require 'bikesched/version'
require 'bikesched/schedule_database'

require 'time'

module Bikesched
  sd = ScheduleDatabase.from_dbpasswd

  shows = sd.range(
    Time.now,
    Time.now + (60 * 60 * 24)
  ).all

  p shows

  show_ids = shows.map { |show| show[:show_id] }
  p show_ids

  p sd.show_names(show_ids, Time.now)
  p sd.show_names(show_ids, Time.now).all
end
