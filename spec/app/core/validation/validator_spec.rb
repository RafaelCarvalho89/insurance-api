# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../app/core/validation/validator'

RSpec.describe Validator do # rubocop:disable Metrics/BlockLength
  let(:validations) do
    {
      name: %i[required type_string],
      age: [:type_integer, { min: 18 }],
      income: [{ max: 150_000 }]
    }
  end

  describe '#valid_rule?' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validations) }

    context 'when rule is a valid symbol' do
      it 'returns true' do
        Validator::RULES_MAPPING.each_key do |rule|
          expect(subject.valid_rule?(rule)).to be true
        end
      end
    end

    context 'when rule is a valid hash' do
      it 'returns true for valid hash rules' do
        expect(subject.valid_rule?(min: 18)).to be true
        expect(subject.valid_rule?(max: 150_000)).to be true
      end
    end

    context 'when rule is an invalid symbol' do
      it 'returns false' do
        expect(subject.valid_rule?(:unknown_rule)).to be false
      end
    end

    context 'when rule is an invalid hash' do
      it 'returns false' do
        expect(subject.valid_rule?(unknown_rule: 'any_value')).to be false
      end
    end

    context 'when rule is an invalid type' do
      it 'returns false' do
        expect(subject.valid_rule?(42)).to be false
      end
    end
  end

  describe '#validate_key_rules' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validations) }

    context 'when all rules are valid' do
      it 'does not raise an error for valid rules' do
        valid_rule_list = %i[required type_string]
        expect { subject.send(:validate_key_rules, valid_rule_list) }.not_to raise_error

        valid_rule_list = [:type_integer, { min: 18 }]
        expect { subject.send(:validate_key_rules, valid_rule_list) }.not_to raise_error

        valid_rule_list = [{ max: 150_000 }]
        expect { subject.send(:validate_key_rules, valid_rule_list) }.not_to raise_error
      end
    end

    context 'when there are invalid rules' do
      it 'raises an error for invalid symbol rules' do
        invalid_rule_list = %i[required unknown_rule]
        expect { subject.send(:validate_key_rules, invalid_rule_list) }
          .to raise_error(ArgumentError, 'unknown_rule validation is not supported')
      end

      it 'raises an error for invalid hash rules' do
        invalid_rule_list = [:type_integer, { unknown_rule: 'any_value' }]
        expect { subject.send(:validate_key_rules, invalid_rule_list) }
          .to raise_error(ArgumentError, '{:unknown_rule=>"any_value"} validation is not supported')
      end

      it 'raises an error for invalid types' do
        invalid_rule_list = [42]
        expect { subject.send(:validate_key_rules, invalid_rule_list) }
          .to raise_error(ArgumentError, '42 validation is not supported')
      end
    end
  end
end
