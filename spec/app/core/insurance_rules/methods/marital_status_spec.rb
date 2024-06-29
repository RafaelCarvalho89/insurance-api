# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/marital_status'

module InsuranceRules
  RSpec.describe MaritalStatusMethods do
    include MaritalStatusMethods

    let(:invalid_marital_status_list) { [-1, {}, [], '1', 'any_string', true, false, nil] }

    describe '#validate_marital_status_input' do
      it 'raises an ArgumentError when the marital status is not a string' do
        expect { validate_marital_status_input(1) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when the marital status is not one of the allowed values' do
        invalid_marital_status_list.each do |value|
          expect { validate_marital_status_input(value) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#married_user?' do
      it 'raises an ArgumentError when the marital status is not a string' do
        invalid_marital_status_list.each do |value|
          expect { married_user?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when the marital status is married' do
        expect(married_user?('married')).to be true
      end

      it 'returns false when the marital status is not married' do
        expect(married_user?('single')).to be false
      end
    end
  end
end
