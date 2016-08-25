require 'journey'

describe Journey do


  subject { described_class.new(station_3) }
  let(:station_6) { double :station, zone: 6 }
  let(:station_3) { double :station, zone: 3 }
  let(:station_1) { double :station, zone: 1}

  it 'records the entry station' do
    expect(subject.instance_variable_get(:@entry_station)).to eq station_3
  end
  it 'records the exit station' do
    subject.finish(station_1)
    expect(subject.instance_variable_get(:@exit_station)).to eq station_1
  end
  it 'calculates correct fare' do
    subject.finish(station_1)
    expect(subject.fare).to eq 3
  end
  it 'calculates correct fare' do
    subject.finish(station_3)
    expect(subject.fare).to eq 1
  end
  it 'calculates correct fare' do
    subject.finish(station_6)
    expect(subject.fare).to eq 4
  end
end
