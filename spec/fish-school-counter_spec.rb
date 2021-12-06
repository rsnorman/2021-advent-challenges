require 'rspec'
require_relative '../fish-school-counter.rb'

RSpec.describe FishSchoolCounter do
  describe '#fish' do
    context 'with no input' do
      it 'returns empty array' do
        expect(subject.fish).to be_empty
      end
    end

    context 'with single fish timer' do
      subject { described_class.new('3') }

      it 'returns single fish with timer at 3' do
        expect(subject.fish.first.timer).to eq 3
      end
    end

    context 'with multiple timers' do
      subject { described_class.new('3,6,0') }

      it 'returns multiple fish with timers set appropriately ' do
        expect(subject.fish.map(&:timer)).to eq([3, 6, 0])
      end
    end

    context 'with fast counter' do
      context 'with no input' do
        subject { described_class.new('', strategy: :fast) }

        it 'returns no fish at any timer position' do
          expect(subject.fish).to eq([0,0,0,0,0,0,0,0,0])
        end
      end

      context 'with single fish timer' do
        subject { described_class.new('3', strategy: :fast) }

        it 'returns single fish with timer at 3' do
          expect(subject.fish).to eq([0,0,0,1,0,0,0,0,0])
        end
      end

      context 'with multiple timers' do
        subject { described_class.new('3,6,0,3', strategy: :fast) }

        it 'returns multiple fish with timers set appropriately ' do
          expect(subject.fish).to eq([1,0,0,2,0,0,1,0,0])
        end
      end
    end
  end

  describe '#tick' do
    context 'with no fish at zero timer' do
      subject { described_class.new('3,6') }

      it 'decrements fish timers' do
        subject.tick
        expect(subject.fish.map(&:timer)).to eq([2, 5])
      end

      it 'doesn\'t add any fish' do
        expect { subject.tick }.not_to change(subject.fish, :size)
      end
    end

    context 'with one fish at zero timer' do
      subject { described_class.new('3,0,6') }

      it 'adds one fish' do
        expect { subject.tick }.to change(subject.fish, :size).by(+1)
      end

      it 'decrements fish timers except new fish' do
        subject.tick
        expect(subject.fish.map(&:timer)).to eq([2, 6, 5, 8])
      end

      context 'with new fish hitting time of 0' do
        before do
          subject.tick_days(9)
        end

        it 'adds one fish' do
          expect { subject.tick }.to change(subject.fish, :size).by(+1)
        end
      end
    end

    context 'with multiple fish at zero timer' do
      subject { described_class.new('3,0,6,0') }

      it 'adds two fish' do
        expect { subject.tick }.to change(subject.fish, :size).by(+2)
      end

      it 'decrements fish timers except new fish' do
        subject.tick
        expect(subject.fish.map(&:timer)).to eq([2, 6, 5, 6, 8, 8])
      end
    end

    context 'with fast counter' do
      context 'with no fish at zero timer' do
        subject { described_class.new('3,6', strategy: :fast) }

        it 'decrements fish timers' do
          subject.tick
          expect(subject.fish).to eq([0,0,1,0,0,1,0,0,0])
        end
      end

      context 'with one fish at zero timer' do
        subject { described_class.new('3,0,6', strategy: :fast) }

        it 'adds a fish to timer 8 position' do
          subject.tick
          expect(subject.fish[8]).to eq 1
        end

        it 'adds a fish to timer 6 position' do
          subject.tick
          expect(subject.fish[6]).to eq 1
        end
      end

      context 'with multiple fish at zero timer' do
        subject { described_class.new('3,0,7,0', strategy: :fast) }

        it 'adds multiple fish to timer 8 position' do
          subject.tick
          expect(subject.fish[8]).to eq 2
        end

        it 'adds multiple fish to timer 6 position' do
          subject.tick
          expect(subject.fish[6]).to eq 3
        end
      end
    end
  end
end
