# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../app/core/validation/rules/hash_keys'
require_relative '../../../../app/core/validation/rules/in'
require_relative '../../../../app/core/validation/rules/max'
require_relative '../../../../app/core/validation/rules/min'
require_relative '../../../../app/core/validation/rules/required'
require_relative '../../../../app/core/validation/rules/type_hash'
require_relative '../../../../app/core/validation/rules/type_integer'
require_relative '../../../../app/core/validation/rules/type_string'
require_relative '../../../../app/core/validation/validator'

RSpec.describe Validator do # rubocop:disable Metrics/BlockLength
  let(:validations) do
    {
      name: %i[required type_string],
      age: [:type_integer, { min: 18 }],
      income: [{ max: 200_000 }]
    }
  end

  let(:params) do
    {
      name: 'John Doe',
      age: 30,
      income: 100_000
    }
  end

  let(:invalid_params) do
    {
      name: 'John Doe',
      age: 15,
      income: 200_000
    }
  end

  describe '#valid_rule?' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validations) }

    context 'when the rule is a valid Symbol' do
      it 'returns true for valid symbol rules' do
        valid_symbols = Validator::RULES_MAPPING.keys

        valid_symbols.each do |symbol|
          expect(subject.send(:valid_rule?, symbol)).to be true
        end
      end
    end

    context 'when the rule is a valid Hash' do
      it 'returns true for valid hash rules' do
        valid_hashes = Validator::RULES_MAPPING.keys.map { |key| { key => nil } }

        valid_hashes.each do |hash|
          expect(subject.send(:valid_rule?, hash)).to be true
        end
      end
    end

    context 'when the rule is an invalid Symbol' do
      it 'returns false for invalid symbol rules' do
        invalid_symbols = %i[unknown_rule another_invalid_rule]

        invalid_symbols.each do |symbol|
          expect(subject.send(:valid_rule?, symbol)).to be false
        end
      end
    end

    context 'when the rule is an invalid Hash' do
      it 'returns false for invalid hash rules' do
        invalid_hashes = [{ unknown_rule: nil }, { another_invalid_rule: nil }]

        invalid_hashes.each do |hash|
          expect(subject.send(:valid_rule?, hash)).to be false
        end
      end
    end

    context 'when the rule is not a Symbol or Hash' do
      it 'returns false for invalid types' do
        invalid_types = [42, 'string', 3.14, [], Object.new]

        invalid_types.each do |invalid_type|
          expect(subject.send(:valid_rule?, invalid_type)).to be false
        end
      end
    end
  end

  describe '#validate_rule' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validations) }

    context 'when the rule is invalid' do
      it 'raises an ArgumentError for invalid symbol rule' do
        expect { subject.send(:validate_rule, :name, :unknown_rule, params) }
          .to raise_error(ArgumentError, 'unknown_rule validation is not supported')
      end

      it 'raises an ArgumentError for invalid hash rule' do
        expect { subject.send(:validate_rule, :name, { unknown_rule: nil }, params) }
          .to raise_error(ArgumentError, '{:unknown_rule=>nil} validation is not supported')
      end
    end

    context 'when the rule validation fails' do
      it 'raises a validation error for invalid age' do
        expect { subject.send(:validate_rule, :age, { min: 18 }, invalid_params) }.to raise_error(StandardError)
      end

      it 'raises a validation error for exceeding income' do
        expect { subject.send(:validate_rule, :income, { max: 150_000 }, invalid_params) }.to raise_error(StandardError)
      end
    end

    context 'when the rule is invalid' do
      it 'raises an ArgumentError for unsupported symbol rule' do
        expect { subject.send(:validate_rule, :name, :unknown_rule, params) }
          .to raise_error(ArgumentError, 'unknown_rule validation is not supported')
      end
    end

    context 'when the rule is valid' do
      it 'validates the rule successfully for symbol rule' do
        validator = described_class.new(validations)

        [
          { name: :required },
          { name: :type_string },
          { age: :type_integer },
          { age: { min: 18 } },
          { income: { max: 200_000 } }
        ].each do |rule|
          rule.each do |key, value|
            expect(validator).to receive(:validate_rule)
              .with(key, value, params)
              .and_return(true)
          end
        end
        validator.call(params)
      end
    end
  end
end
