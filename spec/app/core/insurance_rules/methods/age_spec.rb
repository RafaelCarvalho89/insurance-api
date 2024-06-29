# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/age'

module InsuranceRules
  RSpec.describe AgeMethods do # rubocop:disable Metrics/BlockLength
    include AgeMethods

    let(:invalid_age_list) { [-1, {}, [], '1', 'any_string', true, false, nil] }

    describe '#validate_age_input' do
      it 'raises an ArgumentError when the age is not an integer or is negative' do
        expect { validate_age_input('0') }.to raise_error(ArgumentError)
        expect { validate_age_input(-1) }.to raise_error(ArgumentError)
      end
    end

    describe '# age_less_than_30?' do
      it 'raises an ArgumentError when the age is not an integer or is negative' do
        invalid_age_list.each do |value|
          expect { age_less_than_30?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when the age is less than 30' do
        expect(age_less_than_30?(25)).to be true
      end

      it 'returns false when the age is greater than 30' do
        expect(age_less_than_30?(31)).to be false
      end
    end

    describe '# age_between_30_and_40?' do
      it 'raises an ArgumentError when the age is not an integer' do
        invalid_age_list.each do |value|
          expect { age_between_30_and_40?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when the age is between 30 and 40' do
        expect(age_between_30_and_40?(35)).to be true
      end

      it 'returns false when the age is less than 30 or greater than 40' do
        expect(age_between_30_and_40?(29)).to be false
        expect(age_between_30_and_40?(41)).to be false
      end
    end

    describe '# age_less_than_61?' do
      it 'raises an ArgumentError when the age is not an integer' do
        invalid_age_list.each do |value|
          expect { age_less_than_61?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when the age is less than 61' do
        expect(age_less_than_61?(60)).to be true
      end

      it 'returns false when the age is greater than 61' do
        expect(age_less_than_61?(62)).to be false
      end
    end
  end
end
