# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/in'

RSpec.describe InValidation do
  let(:key_param) { 'key' }
  let(:value_param) { 'a' }
  let(:rule_param) { { in: %w[a b c] } }

  describe '#validate' do
    it 'raises an error if the value is not in the list' do
      invalid_value = 'd'
      validator = described_class.new(key_param, invalid_value, rule_param)
      expect { validator.validate }.to raise_error(ArgumentError, "#{key_param} must be one of #{rule_param[:in]}")
    end

    it 'does not raise an error if the value is in the list' do
      validator = described_class.new(key_param, value_param, rule_param)
      expect { validator.validate }.not_to raise_error
    end
  end
end
