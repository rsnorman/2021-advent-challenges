require 'rspec'
require_relative '../lanternfish.rb'

RSpec.describe Lanternfish do
  describe '#timer' do
    context 'with age not specified' do
      subject { described_class.new }

      it 'returns 8' do
        expect(subject.timer).to eq 8
      end
    end

    context 'with age specified' do
      subject { described_class.new(4) }

      it 'returns specified age' do
        expect(subject.timer).to eq 4
      end
    end
  end

  describe '#tick' do
    context 'with timer not at zero' do
      subject { described_class.new(4) }

      it 'decrements timer' do
        expect { subject.tick }.to change(subject, :timer).from(4).to(3)
      end
    end

    context 'with timer at zero' do
      subject { described_class.new(0) }

      let(:new_lanternfishes) { [] }

      before do
        subject.on_lanternfish_create do |lanterfish|
          new_lanternfishes << lanterfish
        end
      end

      it 'resets timer' do
        expect { subject.tick }.to change(subject, :timer).from(0).to(6)
      end

      it 'notifies that a new lanterfish has been created' do
        expect { subject.tick }.to change(new_lanternfishes, :size).by(+1)
      end

      it 'returns lanternfish with timer at 8' do
        subject.tick
        expect(new_lanternfishes.last.timer).to eq 8
      end
    end
  end
end
