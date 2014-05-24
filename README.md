# Bikesched

**Bikesched** is a wrapper around the URY schedule database.

It is intended to be implemented as a *gateway* gem, which abstracts over the actual source of
schedule information (database, API, etc), and a series of pipelines and filters that massage the
gateway's output into usable formats.  The goal is composability, modularity and non-obsolescence,
not performance.

## Installation

Add this line to your application's Gemfile:

    gem 'bikesched'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install .

## Usage

Bikesched is intended to be usable both as a Ruby gem and as a command-line
interface to the URY schedule.  Results from the latter are intended to be
processed by pipelines as per the Unix philosophy.

The command-line tools are:

* `bikesched_slice <from> <to>` Outputs the timeslots between two UNIX timestamps.
* `fill_slice [jukebox-name]` Fills gaps in the output of `bikesched_slice` with Jukebox timeslots.
* `pretty_slice` Pretty-prints a slice for human consumption.

There are also some shell scripts in the `script` directory that implement
various useful pipeline combinations of the tools:

* `today` Outputs the schedule for today (starting at 7am).

### Examples

#### Next 24 hours of URY shows (FreeBSD)

**Note**: The following example uses FreeBSD-specific `date` features.
One may have to change the `date`s significantly for GNU/Linux.

```
$ echo 'database://connection/string/goes/here' >> dbpasswd
$ bin/bikesched_slice `date +%s` `date -v+1d +%s`
12882	21103	134543	1400860800	1400864400	MASH
12776	21115	134203	1400868000	1400875200	URY:PM - The Teatime Trio
12796	21100	134079	1400875200	1400882400	Circulation Magazine Show 
12804	21095	134253	1400882400	1400886000	The Musicmakers
11601	21117	134282	1400886000	1400889600	Purple Haze
12167	21109	134233	1400918400	1400925600	URY Breakfast: The Weekend Lie-In
12844	21112	134213	1400929200	1400936400	The Harry Whittaker Lunch 
```

## Contributing

1. Fork it ( https://github.com/CaptainHayashi/bikesched/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Q&A

### Why is it called bikesched?

It's a reference to the term 'bikeshedding', which refers to the act of spending a disproportionate
amount of attention on settling trivial arguments (as in, debating the colour a bike-shed should be
instead of actually getting on with building it).

This gem is, itself, a bit of a bikeshed job.  The author realises that URY has more important things
to do than decide how the schedule should be accessed =P

### Why?

Why not?
