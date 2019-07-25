# frozen_string_literal: true

RSpec.describe ListFiller do
  let(:list) do
    %w[
      http://mars.com
      https://venus.com
      https://jupiter.com
      http://neptune.com
    ]
  end
  let(:size) { 20 }
  let(:instance) { described_class.new(list, size: size) }
  describe '#initialize' do
    subject { instance }
    it 'does not raise' do
      block_is_expected.to_not raise_error
    end

    context 'with list smaller than size' do
      it 'fills to <size> entries' do
        expect(instance.list).to_not be_empty
        expect(instance.list.length).to eq(size)
      end
    end

    context 'with list larger than size' do
      let(:size) { 3 }
      it 'fills to <size> entries' do
        expect(instance.list).to_not be_empty
        expect(instance.list.length).to eq(size)
      end
    end
    context 'with size 149 (prime)' do
      let(:size) { 149 }
      it 'fills to <size> entries' do
        expect(instance.list).to_not be_empty
        expect(instance.list.length).to eq(size)
      end
    end
  end

  describe '#list' do
    let(:size) { 12 }
    subject { instance.list }
    it 'returns an Array' do
      is_expected.to be_an(Array)
    end
    context 'length' do
      subject { instance.list.length }
      it 'is size' do
        is_expected.to eq(size)
      end
    end
  end
end
