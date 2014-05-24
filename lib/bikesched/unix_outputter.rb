require 'English'

module Bikesched
  # A schedule formatter that can be used as a source for Unix pipelines
  #
  # Inspired by Eric S. Raymond's glorious book, 'The Art Of Unix Programming'.
  class UnixOutputter
    def initialize(handle = nil, record_separator = nil, field_separator = nil)
      @handle           = handle           || $stdout
      @record_separator = record_separator || "\n"
      @field_separator  = field_separator  || "\t"
    end

    def output_schedule_slice(shows)
      with_separators { shows.each(&method(:schedule_entry)) }
    end

    private

    def with_separators
      old_ofs, old_ors = $OFS, $ORS
      $OFS, $ORS = @field_separator, @record_separator

      yield

      $OFS, $ORS = old_ofs, old_ors
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
