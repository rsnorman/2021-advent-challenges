require 'rspec'
require_relative '../course-reader.rb'

RSpec.describe CourseReader do
  describe '#total_depth' do
    before { subject.read_all }

    it 'does nothing with no input' do
      expect(subject.total_depth).to eq 0
    end

    context 'with moving down once' do
      subject { described_class.new("down 10") }


      it 'returns total depth' do
        expect(subject.total_depth).to eq 0
      end
    end

    context 'with moving down multiple times' do
      subject { described_class.new("down 10\ndown 5\ndown 20") }

      it 'returns total depth' do
        expect(subject.total_depth).to eq 0
      end
    end

    context 'with moving down while moving forward' do
      subject { described_class.new("down 10\nforward 5") }

      it 'returns total depth' do
        expect(subject.total_depth).to eq 50
      end
    end

    context 'with moving down and then back up' do
      subject { described_class.new("down 20\nforward 5\nup 5\nforward 2") }

      it 'returns total depth' do
        expect(subject.total_depth).to eq 130
      end
    end

    context 'with moving down and then back up higher' do
      subject { described_class.new("down 5\nforward 5\nup 10\nforward 2") }

      it 'returns total depth' do
        expect(subject.total_depth).to eq 15
      end
    end
  end

  describe '#total_forward_progress' do
    before { subject.read_all }

    it 'does nothing with no input' do
      expect(subject.total_horizontal_progress).to eq 0
    end

    context 'with moving down once' do
      subject { described_class.new("forward 10") }

      it 'returns total forward progress' do
        expect(subject.total_horizontal_progress).to eq 10
      end
    end

    context 'with moving down multiple times' do
      subject { described_class.new("forward 10\nforward 5\nforward 20") }

      it 'returns total forward progress' do
        expect(subject.total_horizontal_progress).to eq 35
      end
    end

    context 'with moving down while moving forward' do
      subject { described_class.new("down 10\nforward 5\ndown 20") }

      it 'returns total forward progress' do
        expect(subject.total_horizontal_progress).to eq 5
      end
    end
  end

  describe '#total_moves' do
    context 'with no input' do
      it 'returns 0' do
        expect(subject.total_moves).to be_zero
      end
    end

    context 'with input' do
      subject { described_class.new("forward 10\ndown 20\nup 4") }

      it 'returns 3' do
        expect(subject.total_moves).to eq 3
      end
    end
  end

  describe '#course_multiplied' do
    before { subject.read_all }

    context 'with no input' do
      it 'returns 0' do
        expect(subject.course_multiplied).to eq 0
      end
    end

    context 'with no moves forward' do
      subject { described_class.new("down 10\nup 3") }

      it 'returns 0' do
        expect(subject.course_multiplied).to eq 0
      end
    end

    context 'with no moves down or up' do
      subject { described_class.new("forward 10\nforward 3") }

      it 'returns 0' do
        expect(subject.course_multiplied).to eq 0
      end
    end

    context 'with moves forward and down/up' do
      subject { described_class.new("forward 10\ndown 15\nup 5\nforward 3") }

      it 'returns forward progress multplied by depth' do
        expect(subject.course_multiplied).to eq 390
      end
    end
  end
end
