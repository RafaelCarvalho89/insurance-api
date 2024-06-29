# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/type_string'

RSpec.describe TypeStringValidation do
  let(:key_param) { 'key' }
  let(:value_param) { 'value' }
  let(:rule_param) { nil }
  let(:invalid_value_param_list) { [1, 1.0, true, false, nil, [], {}] }

  describe '#validate' do
    it 'raises an error if the value is not a string' do
      invalid_value_param_list.each do |value|
        rule = described_class.new(key_param, value, rule_param)
        expect { rule.validate }.to raise_error(ArgumentError, "#{key_param} must be a string")
      end
    end

    it 'does not raise an error if the value is a string' do
      rule = described_class.new(key_param, value_param, rule_param)
      expect { rule.validate }.not_to raise_error
    end
  end
end
