require 'spec_helper'
require 'bikesched/schedule'
require 'time'

RSpec.describe 'Bikesched::Schedule' do
  let(:source) { double(:source) }
  let(:from)   { Time.parse('2010-01-01 13:50:00 +0000') }

  subject { Bikesched::Schedule.new(source) }

  describe '#from' do
    context 'with a Time' do
      it 'returns a ScheduleFrom' do
        expect(subject.from(from)).to be_a(Bikesched::ScheduleFrom)
      end
    end
  end

  describe '#time_range' do
    context 'with two Times' do
      context 'with the end time after the start time' do
        let(:to) { from + (60 * 60 * 24) }

        it 'calls #range on the database with the given times' do
          allow(source).to receive(:range)
          subject.time_range(from, to)
          expect(source).to have_received(:range).once.with(from, to)
        end
      end
    end
  end
end
