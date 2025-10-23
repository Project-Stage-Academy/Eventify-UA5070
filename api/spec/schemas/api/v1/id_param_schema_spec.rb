require 'rails_helper'

RSpec.describe Api::V1::IdParamSchema do
  subject(:schema) { described_class }

  context 'when :id is valid' do
    it 'successfully validates an integer' do
      result = schema.call(id: 123)
      expect(result).to be_success
    end

    it 'successfully validates a string coercible to an integer' do
      result = schema.call(id: '456')
      expect(result).to be_success
      expect(result.to_h).to eq(id: 456)
    end
  end

  context 'when :id is invalid' do
    it 'returns an error if :id is missing' do
      result = schema.call({})
      expect(result).to be_failure
      expect(result.errors[:id]).to include('is missing')
    end

    it 'returns an error if :id is an empty string' do
      result = schema.call(id: '')
      expect(result).to be_failure
      expect(result.errors[:id]).to include('must be filled')
    end

    it 'returns an error if :id is not an integer' do
      result = schema.call(id: 'abc')
      expect(result).to be_failure
      expect(result.errors[:id]).to include('must be an integer')
    end

    it 'returns an error if :id is 0 (fails gt?: 0)' do
      result = schema.call(id: 0)
      expect(result).to be_failure
      expect(result.errors[:id]).to include('must be greater than 0')
    end
  end
end
