require 'sequel'

module Bikesched
  # An object providing a connection to the URY schedule database
  class ScheduleDatabase
    [ #  CONSTANT     SCHEMA   TABLE
      %i{SHOW         schedule show},
      %i{SEASON       schedule show_season},
      %i{TIMESLOT     schedule show_season_timeslot},

      %i{SHOW_TMD     schedule show_metadata},
      %i{SEASON_TMD   schedule show_season_metadata},
      %i{TIMESLOT_TMD schedule show_season_timeslot_metadata},

      %i{META_KEYS    metadata metadata_key}
    ].each { |id, *db_name| const_set(id, Sequel.qualify(*db_name)) }

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
      from_query(raw_range(from, to))
    end

    # Fetches all information about the 'count' timeslots from 'from'
    def count(from, count)
      from_query(raw_count(from, count))
    end

    def from_query(query)
      timeslots  = query.all
      show_ids   = timeslots.map { |show| show[:show_id] }
      show_names = show_names(show_ids, Time.now)

      timeslots.map do |show|
        show.merge(show_name: show_names[show[:show_id]])
      end
    end

    def raw_range(from, to)
      select_slice_from(from).and { start_time < to }
    end

    def raw_count(from, count)
      select_slice_from(from).limit(count)
    end

    def select_slice_from(time)
      @db[TIMESLOT].join(SEASON, [:show_season_id])
             .join(SHOW, [:show_id])
             .select_append { (start_time + duration).as(end_time) }
             .order_by      { start_time.asc }
             .where         { start_time + duration >= time }
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
