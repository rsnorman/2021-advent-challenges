require 'rspec'
require_relative '../vent-mapper.rb'

RSpec.describe VentMapper do
  describe '#vents' do
    context 'with no vents' do
      it 'returns empty array' do
        expect(subject.vents).to be_empty
      end
    end

    context 'with single vent' do
      subject { described_class.new('0,9 -> 5,9') }

      it 'returns vent' do
        expect(subject.vents.first).to eq([[0,9],[5,9]])
      end
    end

    context 'with multiple vents' do
      subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8") }

      it 'returns vent' do
        expect(subject.vents).to eq([[[0,9],[5,9]],[[8,0],[0,8]]])
      end
    end
  end

  describe '#vent_map' do
    subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8") }

    it 'returns map width of max x coordinate' do
      expect(subject.vent_map.first.size).to eq 9
    end

    it 'returns map height of max y coordinate' do
      expect(subject.vent_map.size).to eq 10
    end

    it 'maps non-overlapped vent' do
      expect(subject.vent_map[9][0]).to eq 1
      expect(subject.vent_map[9][1]).to eq 1
      expect(subject.vent_map[9][2]).to eq 1
      expect(subject.vent_map[9][3]).to eq 1
      expect(subject.vent_map[9][4]).to eq 1
      expect(subject.vent_map[9][5]).to eq 1
    end

    it 'does\'t map non-overlapped vent' do
      expect(subject.vent_map[8][0]).to eq 0
      expect(subject.vent_map[9][6]).to eq 0
      expect(subject.vent_map[0][2]).to eq 0
      expect(subject.vent_map[0][0]).to eq 0
    end

    context 'with overlapped vent' do
      subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8\n3,1 -> 3,9") }

      it 'maps overlapped vents' do
        expect(subject.vent_map[9][3]).to eq 2
        puts subject.vent_map.inspect
      end
    end
  end

  describe '#overlap_points' do
    context 'with no overlap points' do
      subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8") }

      it 'returns 0' do
        expect(subject.overlap_points).to be_zero
      end
    end

    context 'with single overlap point' do
      subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8\n3,1 -> 3,9") }

      it 'returns 1 point' do
        expect(subject.overlap_points).to eq 1
      end
    end

    context 'with multiple overlap points' do
      subject { described_class.new("0,9 -> 5,9\n8,0 -> 0,8\n3,1 -> 3,9\n1,9 -> 2,9") }

      it 'returns 3 points' do
        expect(subject.overlap_points).to eq 3
      end
    end
  end
end
