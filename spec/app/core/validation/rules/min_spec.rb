# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/min'

RSpec.describe MinValidation do
  let(:key_param) { 'key' }
  let(:value_param) { 10 }
  let(:rule_param) { { min: 10 } }

  it 'raises an error if the value is less than the minimum' do
    invalid_value_param = 9
    validator = described_class.new(key_param, invalid_value_param, rule_param)

    expect { validator.validate }
      .to raise_error(ArgumentError, "#{key_param} must be at least #{rule_param[:min]}")
  end

  it 'does not raise an error if the value is greater than the minimum' do
    validator = described_class.new(key_param, value_param, rule_param)
    expect { validator.validate }.not_to raise_error
  end
end
