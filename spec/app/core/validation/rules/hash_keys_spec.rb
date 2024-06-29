# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/hash_keys'

RSpec.describe HashKeysValidation do
  let(:key_param) { 'key' }
  let(:value_param) { { a: 1, b: 2, c: 3, d: 4 } }
  let(:rule_param) { { keys: %w[a b c d] } }

  describe '#validate' do
    it 'raises an error if the hash does not contain all the keys' do
      invalid_value = { a: 1, b: 2, c: 3 }
      validator = described_class.new(key_param, invalid_value, rule_param)
      expect { validator.validate }.to raise_error(ArgumentError)
    end
  end
end
