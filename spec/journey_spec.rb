require 'journey'

describe Journey do

  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  let(:oyster)  { double :oyster }

  it 'remembers a full journey' do
    subject.start(entry_station)
    subject.finish(exit_station)
    expect(subject.journey).to include(:entry_station => entry_station, :exit_station => exit_station)
  end

  
end
