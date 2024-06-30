# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/type_hash'

RSpec.describe TypeHashValidation do
  let(:key_param) { 'key' }
  let(:value_param) { {} }
  let(:rule_param) { nil }

  describe '#validate' do
    it 'raises an error if the value is not a hash' do
      invalid_value = 'a'
      validator = described_class.new(key_param, invalid_value, rule_param)
      expect { validator.validate }.to raise_error(ArgumentError, "#{key_param} must be a hash")
    end

    it 'does not raise an error if the value is a hash' do
      validator = described_class.new(key_param, value_param, rule_param)
      expect { validator.validate }.not_to raise_error
    end
  end
end
