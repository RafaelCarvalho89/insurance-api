# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../app/core/insurance_rules/module'

RSpec.describe InsuranceRules::Utils do # rubocop:disable Metrics/BlockLength
  let(:dummy_class) { Class.new { extend InsuranceRules::Utils } }

  describe '#array_of_strings?' do
    it 'returns true for an array of strings' do
      expect(dummy_class.array_of_strings?(%w[string1 string2])).to be true
    end

    it 'returns false for an empty array' do
      expect(dummy_class.array_of_strings?([])).to be false
    end

    it 'returns false for an array of non-strings' do
      expect(dummy_class.array_of_strings?([1, 2, 3])).to be false
    end

    it 'returns false for a mixed array' do
      expect(dummy_class.array_of_strings?(['string', 1])).to be false
    end

    it 'returns false for a non-array input' do
      expect(dummy_class.array_of_strings?('string')).to be false
    end
  end

  describe '#build_validations' do # rubocop:disable Metrics/BlockLength
    let(:validation_config_map) do
      {
        age: [:required, :type_integer, { min: 0 }, { max: 120 }],
        house: [:required, :type_hash, { keys: [:ownership_status] }],
        income: [:required, :type_integer, { min: 0 }],
        marital_status: [:required, :type_string, { in: %w[single married] }],
        risk_questions: [:required], # TODO: :type_array_of_boolean
        user_dependents: [:required, :type_integer, { min: 0 }],
        vehicle: [:required, :type_hash, { keys: [:year] }]
      }
    end

    before do
      stub_const('InsuranceRules::CONSTANTS::VALIDATION_CONFIG_MAP', validation_config_map)
    end

    it 'returns a hash of validations for a valid array of strings' do
      param_name_list = %w[age house income marital_status risk_questions user_dependents vehicle].freeze
      expected_result = {
        age: [:required, :type_integer, { min: 0 }, { max: 120 }],
        house: [:required, :type_hash, { keys: [:ownership_status] }],
        income: [:required, :type_integer, { min: 0 }],
        marital_status: [:required, :type_string, { in: %w[single married] }],
        risk_questions: [:required], # TODO: :type_array_of_boolean
        user_dependents: [:required, :type_integer, { min: 0 }],
        vehicle: [:required, :type_hash, { keys: [:year] }]
      }

      result = dummy_class.build_validations(param_name_list)

      expect(result).to eq(expected_result)
    end

    context 'when occurs an error' do
      it 'raises an ArgumentError for an invalid param_name_list' do
        invalid_param_name_list = [1, 2, 3]

        expect { dummy_class.build_validations(invalid_param_name_list) }
          .to raise_error(ArgumentError, 'param_name_list must be an array of strings')
      end

      it 'raises an ArgumentError for an empty param_name_list' do
        empty_param_name_list = []

        expect { dummy_class.build_validations(empty_param_name_list) }
          .to raise_error(ArgumentError, 'param_name_list must be an array of strings')
      end

      it 'raises an ArgumentError for a mixed param_name_list' do
        mixed_param_name_list = ['param1', 1]

        expect { dummy_class.build_validations(mixed_param_name_list) }
          .to raise_error(ArgumentError, 'param_name_list must be an array of strings')
      end
    end
  end
end
