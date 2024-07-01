# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../app/validation/rules/type_integer'

RSpec.describe TypeIntegerValidation do
  let(:key_param) { 'key' }
  let(:value_param) { 1 }
  let(:rule_param) { nil }
  let(:invalid_value_param_list) { [1.0, true, false, nil, [], {}, 'value'] }

  describe '# validate' do
    it 'raises an ArgumentError' do
      invalid_value_param_list.each do |value|
        validator = described_class.new(key_param, value, rule_param)
        expect { validator.validate }.to raise_error(ArgumentError, "#{key_param} must be an integer")
      end
    end

    it 'does not raise an error if the value is an integer' do
      validator = described_class.new(key_param, value_param, rule_param)
      expect { validator.validate }.not_to raise_error
    end
  end
end
