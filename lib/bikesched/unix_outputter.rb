require 'English'

module Bikesched
  class UnixOutputter
    def initialize(handle=nil, record_separator=nil, field_separator=nil)
      @handle           = handle           || $stdout
      @record_separator = record_separator || "\n"
      @field_separator  = field_separator  || "\t"
    end

    def output_schedule_slice(shows)
      with_separators { shows.each(&method(:schedule_entry)) }
    end

    private

    def with_separators
      @old_OFS, @old_ORS = $OFS, $ORS
      $OFS, $ORS = @field_separator, @record_separator

      yield

      $OFS, $ORS = @old_OFS, @old_ORS
    end

    def escape(string)
      string.gsub('\\', '\\\\\\\\')
            .gsub($OFS, '\\\\t')
	    .gsub($ORS, '\\\\n')
    end

    def schedule_entry(show)
      @handle.print(show[:show_id],
                    show[:show_season_id],
                    show[:show_season_timeslot_id],
                    show[:start_time].to_i,
                    show[:end_time].to_i,
                    escape(show[:show_name]))
    end
  end
end
