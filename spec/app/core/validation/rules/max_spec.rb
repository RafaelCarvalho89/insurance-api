# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/max'

RSpec.describe MaxValidation do
  let(:key_param) { 'key' }
  let(:value_param) { 10 }
  let(:rule_param) { { max: 10 } }

  it 'raises an error if the value is greater than the maximum' do
    invalid_value_param = 11
    validator = described_class.new(key_param, invalid_value_param, rule_param)

    expect { validator.validate }
      .to raise_error(ArgumentError, "#{key_param} must be at most #{rule_param[:max]}")
  end

  it 'does not raise an error if the value is less than the maximum' do
    validator = described_class.new(key_param, value_param, rule_param)
    expect { validator.validate }.not_to raise_error
  end
end
