# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../app/validation/rule'

# ValidationRule class
RSpec.describe ValidationRule do
  let(:key_value) { 'key' }
  let(:value_value) { 'value' }
  let(:rule_value) { 'rule' }

  describe '# validate' do
    it 'raises an NotImplementedError' do
      rule = ValidationRule.new(key_value, value_value, rule_value)
      expect { rule.validate }.to raise_error(NotImplementedError)
    end
  end

  describe '# initialize' do
    it 'initializes the key, value and rule' do
      rule = ValidationRule.new(key_value, value_value, rule_value)

      expect(rule.key).to eq(key_value)
      expect(rule.value).to eq(value_value)
      expect(rule.rule).to eq(rule_value)
    end
  end
end
