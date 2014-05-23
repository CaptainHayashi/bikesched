require 'spec_helper'
require 'bikesched/schedule'
require 'time'

RSpec.describe Bikesched::Schedule do
  let(:source) { double(:source) }
  let(:from)   { Time.parse('2010-01-01 13:50:00 +0000') }
  let(:sched)  { Bikesched::Schedule.new(source) }
  subject      { sched }

  describe '#from' do
    subject { sched.from(from) }
    context 'with a Time' do
      it { is_expected.to be_a(Bikesched::ScheduleFrom) }
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

RSpec.describe Bikesched::ScheduleFrom do
  let(:source) { double(:source) }
  let(:from)   { Time.parse('2010-01-01 13:50:00 +0000') }
  let(:sched)  { Bikesched::Schedule.new(source) }
  let(:sfrom)  { sched.from(from) }
  subject      { sfrom }

  describe '#to' do
    subject { sfrom.to(to) }

    context 'with a time after the start time' do
      let(:to) { from + (60 * 60 * 24) }

      it 'calls #time_range on the schedule with the given times' do
        allow(sched).to receive(:time_range)
        subject
        expect(sched).to have_received(:time_range).once.with(from, to)
      end
    end

    context 'with a time before the start time' do
      let(:to) { from - (60 * 60 * 24) }
      it 'fails with an error without calling #time_range' do
        allow(sched).to receive(:time_range)
        expect(sched).to_not receive :time_range
        expect { subject }.to raise_error 'End time before start time.'
      end
    end
  end

  describe '#for' do
    subject { sfrom.for(duration) }

    context 'with a non-negative integer' do
      let(:duration) { 60 * 60 * 24 }
      it { is_expected.to be_a(Bikesched::ScheduleFor) }
    end

    context 'with a negative integer' do
      let(:duration) { -60 * 60 * 24 }
      specify { expect { subject }.to raise_error 'Duration negative.' }
    end
  end
end
