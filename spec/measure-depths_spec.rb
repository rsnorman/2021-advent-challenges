require 'rspec'
require_relative '../measure-depth.rb'

RSpec.describe DepthMeasurer do
  subject { described_class.new('100') }

  describe '#measure' do
    it 'returns no previous measurement' do
      expect(subject.measure).to eq 'N/A - no previous measurement'
    end
  end
end
