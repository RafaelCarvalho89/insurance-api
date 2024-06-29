# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/validation/rules/required'

RSpec.describe RequiredValidation do
  let(:key_value) { 'key' }
  let(:value_value) { nil }
  let(:rule_value) { nil }

  describe '# validate' do
    it 'raises an ArgumentError' do
      rule = RequiredValidation.new(key_value, value_value, rule_value)
      expect { rule.validate }.to raise_error(ArgumentError)
    end
  end
end
