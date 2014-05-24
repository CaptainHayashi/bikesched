# Bikesched

**Bikesched** is a wrapper around the URY schedule database.

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

* `bikesched-slice <from> <to>` Outputs the timeslots between two UNIX timestamps.

### Next 24 hours of URY shows (FreeBSD)

**Note**: The following example uses FreeBSD-specific `date` features.
One may have to change the `date`s significantly for GNU/Linux.

```
$ echo 'database://connection/string/goes/here' >> dbpasswd
$ bin/bikesched-slice `date +%s` `date -v+1d +%s`
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
