require 'sequel'

module Bikesched
  # An object providing a connection to the URY schedule database
  class ScheduleDatabase
    # Schedule tables
    SHOW     = Sequel.qualify(:schedule, :show)
    SEASON   = Sequel.qualify(:schedule, :show_season)
    TIMESLOT = Sequel.qualify(:schedule, :show_season_timeslot)

    # Metadata tables
    SHOW_TMD     = Sequel.qualify(:schedule, :show_metadata)
    SEASON_TMD   = Sequel.qualify(:schedule, :show_season_metadata)
    TIMESLOT_TMD = Sequel.qualify(:schedule, :show_season_timeslot_metadata)

    META_KEYS    = Sequel.qualify(:metadata, :metadata_key)

    # Constructs a new ScheduleDatabase
    def initialize(db)
      @db = db
    end

    # Constructs a ScheduleDatabase from a local 'dbpasswd' file
    def self.from_dbpasswd
      dbpasswd = IO.read('dbpasswd').chomp
      ScheduleDatabase.new(Sequel.connect(dbpasswd))
    end

    # Fetches all information about the timeslots between from and to
    def range(from, to)
      timeslots  = raw_range(from, to).all
      show_ids   = timeslots.map { |show| show[:show_id] }
      show_names = show_names(show_ids, Time.now)

      timeslots.map do |show|
        show.merge(show_name: show_names[show[:show_id]])
      end
    end

    def raw_range(from, to)
      @db[TIMESLOT].join(SEASON, [:show_season_id])
                   .join(SHOW, [:show_id])
                   .select_append { (start_time + duration).as(end_time) }
                   .order_by      { start_time.asc }
                   .where         { start_time + duration >= from }
                   .and           { start_time < to }
    end

    # Returns the names of the shows whose ids are in 'ids' at 'time'
    def show_names(ids, time)
      @db[SHOW_TMD].select(:show_id, :metadata_value)
                   .distinct(:show_id)
                   .join(META_KEYS, [:metadata_key_id])
                   .order_by(:show_id, Sequel.desc(:effective_to))
                   .where(show_id: ids, name: 'title')
                   .and      { effective_from <= time }
                   .and      { (effective_to.nil?) | (effective_to > time) }
                   .to_hash(:show_id, :metadata_value)
    end
  end
end
