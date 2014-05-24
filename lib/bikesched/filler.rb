module Bikesched
  class Filler
    def initialize(name='Jukebox', filler_entry_proc=method(:default_fill))
      @name              = name
      @filler_entry_proc = filler_entry_proc
    end

    # Fills a list of slots
    #
    # Each slot will be yielded 
    def fill(slots, &block=method(:ignore))
      to_lazy_pairs(slots).flat_map(&method(:try_fill_pair)).each(&block).force
    end

    private

    # Tries filling between a pair if necessary
    def try_fill_pair(pair)
      result = [pair.first]
      result << fill_pair(pair) if gap?(*&pair)
      result
    end

    # Converts a list of slots to a lazy enumerator of slot pairs
    # 
    # For a list of slots [a, b, c, ..., z] this will enumerate
    # [[a, b], [b, c], [c, d], ..., [z, nil]].
    def to_lazy_pairs(slots)
      slots.lazy.zip(slots.lazy.drop(1))
    end

    # Decides whether there is a gap between two slots
    def gap?(this_slot, next_slot)
      !(next_slot.nil? || next_slot.start_time == this_slot.finish_time)
    end

    def default_fill(start, finish)
      { show_id: nil,
        show_season_id: nil,
        show_season_timeslot_id: nil,
        start_time: start,
        finish_time: finish,
        show_name: @name }
    end

    def ignore(*_)
    end
  end
end
