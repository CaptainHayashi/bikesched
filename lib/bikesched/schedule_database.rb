require 'sequel'

module Bikesched
  class ScheduleDatabase
    SHOW     = Sequel.qualify(:schedule, :show)
    SEASON   = Sequel.qualify(:schedule, :show_season)
    TIMESLOT = Sequel.qualify(:schedule, :show_season_timeslot)

    SHOW_TMD     = Sequel.qualify(:schedule, :show_metadata)
    SEASON_TMD   = Sequel.qualify(:schedule, :show_season_metadata)
    TIMESLOT_TMD = Sequel.qualify(:schedule, :show_season_timeslot_metadata)

    META_KEYS    = Sequel.qualify(:metadata, :metadata_key)

    def initialize(db)
      @db = db
    end

    def self.from_dbpasswd
      dbpasswd = IO.read('dbpasswd').chomp
      ScheduleDatabase.new(Sequel.connect(dbpasswd))
    end

    def range(from, to)
      @db[TIMESLOT].join(SEASON, [:show_season_id])
                   .join(SHOW, [:show_id])
                   .where    { start_time + duration >= from }
                   .and      { start_time < to }
                   .order_by { start_time.asc }
    end

    def show_names(ids, time)
      @db[SHOW_TMD].select(:show_id, :metadata_value)
                   .distinct(:show_id)
                   .join(META_KEYS, [:metadata_key_id])
                   .where(show_id: ids, name: 'title')
                   .and      { effective_from <= time }
                   .and      { (effective_to.nil?) | (effective_to > time) }
                   .order_by(:show_id, Sequel.desc(:effective_to))
    end
  end
end
