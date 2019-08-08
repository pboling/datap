# frozen_string_literal: true

RSpec.describe ListFiller do
  subject(:instance) { described_class.new(input, size: size) }

  let(:input) do
    %w[
      http://mars.com
      https://venus.com
      https://jupiter.com
      http://neptune.com
    ]
  end
  let(:size) { input.length }

  describe '#initialize' do
    it 'does not raise' do
      block_is_expected.not_to raise_error
    end

    context 'with list same size as input' do
      subject(:list) { instance.list }

      it 'is not empty' do
        expect(list).not_to be_empty
      end
      it 'fills to <size> entries' do
        expect(list.length).to eq(size)
      end
    end

    context 'with list smaller than size' do
      subject(:list) { instance.list }

      let(:size) { input.length + 1 }

      it 'is not empty' do
        expect(list).not_to be_empty
      end
      it 'fills to <size> entries' do
        expect(list.length).to eq(size)
      end
    end

    context 'with list larger than size' do
      subject(:list) { instance.list }

      let(:size) { input.length - 1 }

      it 'is not empty' do
        expect(list).not_to be_empty
      end
      it 'fills to <size> entries' do
        expect(list.length).to eq(size)
      end
    end

    context 'with size 149 (prime)' do
      subject(:list) { instance.list }

      let(:size) { 149 }

      it 'is not empty' do
        expect(list).not_to be_empty
      end
      it 'fills to <size> entries' do
        expect(list.length).to eq(size)
      end
    end
  end

  describe '#list' do
    subject(:list) { instance.list }

    let(:size) { 12 }

    it 'returns an Array' do
      is_expected.to be_an(Array)
    end
    it 'has length' do
      expect(list.length).to eq(size)
    end
  end
end
