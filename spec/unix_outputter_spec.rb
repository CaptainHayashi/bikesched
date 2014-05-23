require 'bikesched/unix_outputter'
require 'spec_helper'
require 'time'

RSpec.describe Bikesched::UnixOutputter do
  describe '#output_schedule_slice' do
    let(:slice) do
      [
        { show_id:                 101,
          show_season_id:          10101,
          show_season_timeslot_id: 1010101,
          start_time:              Time.parse('2010-01-01 13:50:00 +0000'),
          end_time:                Time.parse('2010-01-01 15:50:00 +0000'),
          show_name:               "URY:PM: \\Backslash\\ \nNewline \\n"
        }
      ]
    end
    context 'with the default settings and a StringIO' do
      it 'produces correct output' do
        str = StringIO.open do |strio|
          Bikesched::UnixOutputter.new(strio).output_schedule_slice(slice)
          strio.string
        end

        expect(str).to eq(
          [ "101",
            "10101",
            "1010101",
            slice[0][:start_time].to_i,
            slice[0][:end_time].to_i,
            'URY\:PM\: \\\\Backslash\\\\ \nNewline \\\\n'
          ].join(':') + "\n"
        )
      end
    end
  end
end
