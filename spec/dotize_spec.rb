require 'spec_helper'

describe Dotize do
  it 'has a version number' do
    expect(Dotize::VERSION).not_to be nil
  end

  describe '#dot' do
    before(:each) { subject.extend(Dotize) }

    describe 'finding a property' do
      subject do
        { 'a' => 123 }
      end

      it 'returns the corresponding value' do
        expect(subject.dot('a')).to equal(123)
      end
    end

    describe 'handling falsey values' do
      subject do
        { 'a' => false, 'b' => nil }
      end

      it 'returns false' do
        result = subject.dot('a') { raise 'Default should not be called' }
        expect(result).to eq(false)
      end

      it 'returns nil' do
        result = subject.dot('b') { raise 'Default should not be called' }
        expect(result).to be_nil
      end
    end

    context 'nested property' do
      subject do
        { 'a' => { 'b' => 456 } }
      end

      it 'returns the corresponding value' do
        expect(subject.dot('a.b')).to equal(456)
      end

      describe 'when the property does not exist' do
        it 'returns nil' do
          expect(subject.dot('a.z')).to be_nil
        end
      end

      describe 'when the selector matches a non-hash-like object midway' do
        it 'returns nil' do
          expect(subject.dot('a.b.z')).to be_nil
        end
      end
    end

    describe 'default block' do
      subject do
        { 'a' => 123 }
      end

      describe 'when a property is not found' do
        it 'returns the value from the block provided' do
          result = subject.dot('z') { 2 + 2 }
          expect(result).to equal(4)
        end

        it 'passes the subject to the block' do
          result = subject.dot('z') { |hash| hash.keys }
          expect(result).to contain_exactly('a')
        end

        it 'does not calculate the default multiple times' do
          times_block_called = 0
          default_block = Proc.new do
            times_block_called += 1
            2 + 2
          end

          result = subject.dot('z.z.z.z', &default_block)

          expect(result).to eq(4)
          expect(times_block_called).to eq(1)
        end
      end

      describe 'when all properties found' do
        it 'does not call the default block' do
          result = subject.dot('a') { raise 'Default should not be called' }
          expect(result).to equal(123)
        end
      end
    end
  end
end
