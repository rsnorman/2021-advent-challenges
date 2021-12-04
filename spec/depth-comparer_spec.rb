require 'rspec'
require_relative '../depth-comparer.rb'

RSpec.describe DepthComparer do
  subject { described_class.new('100') }

  describe '#measure' do
    context 'with no previous measurement' do
      it 'returns no previous measurement' do
        expect(subject.measure).to eq 'N/A - no previous measurement'
      end
    end

    context 'with second measurement a decrease in depth' do
      subject { described_class.new("100\n99") }

      before { subject.measure }

      it 'returns decrease' do
        expect(subject.measure).to eq 'decreased'
      end
    end

    context 'with second measurement an increase in depth' do
      subject { described_class.new("100\n101") }

      before { subject.measure }

      it 'returns increase' do
        expect(subject.measure).to eq 'increased'
      end
    end

    context 'with second measurement the same as first' do
      subject { described_class.new("100\n100") }

      before { subject.measure }

      it 'returns no change' do
        expect(subject.measure).to eq 'no change'
      end
    end
  end
end
