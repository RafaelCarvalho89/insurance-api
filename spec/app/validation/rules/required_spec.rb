# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../app/validation/rules/required'

RSpec.describe RequiredValidation do
  let(:key_param) { 'key' }
  let(:value_param) { nil }
  let(:rule_param) { nil }
  let(:valid_value_param_list) { [1, 1.0, true, false, [], {}, 'value'] }

  describe '# validate' do
    it 'raises an ArgumentError' do
      validator = described_class.new(key_param, value_param, rule_param)
      expect { validator.validate }.to raise_error(ArgumentError, "#{key_param} is required")
    end
  end

  it 'does not raise an error if the value is not nil' do
    valid_value_param_list.each do |value|
      validator = described_class.new(key_param, value, rule_param)
      expect { validator.validate }.not_to raise_error
    end
  end
end
