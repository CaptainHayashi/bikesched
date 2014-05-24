require 'forwardable'

module Bikesched
  class Filler
    extend Forwardable

    def initialize(args={})
      @name         = args[:name]        || 'Jukebox'
      @fill_proc    = args[:fill_proc]   || method(:default_fill)
      @start_proc   = args[:start_proc]  || ->(show) { show[:start_time] }
      @finish_proc  = args[:finish_proc] || ->(show) { show[:finish_time] }
    end

    # Fills a list of slots
    #
    # Each slot after filling will be yielded to the block.
    def fill(slots, &block)
      @just_started = true
      to_lazy_pairs(slots.lazy).flat_map(&method(:try_fill_pair)).each(&block)
    end

    private

    # Tries filling between a pair if necessary
    def try_fill_pair(pair)
      result = []
      result << pair.first       if @just_started
      @just_started = false

      result << fill_pair(*pair) if gap?(*pair)
      result << pair.last
      result
    end

    def fill_pair(this_slot, next_slot)
      fill_between(finish_of(this_slot), start_of(next_slot))
    end

    # Converts a list of slots to a lazy enumerator of slot pairs
    # 
    # For a list of slots [a, b, c, ..., z] this will enumerate
    # [[a, b], [b, c], [c, d], ..., [z, nil]].
    def to_lazy_pairs(slots)
      slots.each_cons(2)
    end

    # Decides whether there is a gap between two slots
    def gap?(this_slot, next_slot)
      !(next_slot.nil? || finish_of(this_slot) == start_of(next_slot))
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

    def_delegator :@fill_proc,   :call, :fill_between
    def_delegator :@finish_proc, :call, :finish_of
    def_delegator :@start_proc,  :call, :start_of
  end
end
