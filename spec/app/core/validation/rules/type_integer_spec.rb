# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/type_integer'

RSpec.describe TypeIntegerValidation do
  let(:key_value) { 'key' }
  let(:value_value) { 'value' }
  let(:rule_value) { nil }

  describe '# validate' do
    it 'raises an ArgumentError' do
      rule = TypeIntegerValidation.new(key_value, value_value, rule_value)
      expect { rule.validate }.to raise_error(ArgumentError)
    end
  end
end
