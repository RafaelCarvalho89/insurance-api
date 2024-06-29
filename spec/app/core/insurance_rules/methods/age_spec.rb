# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/age'

module InsuranceRules
  RSpec.describe AgeMethods do # rubocop:disable Metrics/BlockLength
    include AgeMethods

    describe '#age_zero_or_more?' do
      it 'raises an ArgumentError when the age is not an integer' do
        expect { age_zero_or_more?('0') }.to raise_error(ArgumentError)
      end

      it 'returns true when the age is zero or more' do
        expect(age_zero_or_more?(0)).to be true
      end

      it 'returns false when the age is negative' do
        expect(age_zero_or_more?(-1)).to be false
      end
    end

    describe '#age_less_than_30?' do
      it 'raises an ArgumentError when the age is not an integer' do
        expect { age_less_than_30?('25') }.to raise_error(ArgumentError)
      end

      it 'returns true when the age is less than 30' do
        expect(age_less_than_30?(25)).to be true
      end

      it 'returns false when the age is greater than 30' do
        expect(age_less_than_30?(31)).to be false
      end
    end

    describe '#age_between_30_and_40?' do
      it 'raises an ArgumentError when the age is not an integer' do
        expect { age_between_30_and_40?('35') }.to raise_error(ArgumentError)
      end

      it 'returns true when the age is between 30 and 40' do
        expect(age_between_30_and_40?(35)).to be true
      end

      it 'returns false when the age is less than 30 or greater than 40' do
        expect(age_between_30_and_40?(29)).to be false
        expect(age_between_30_and_40?(41)).to be false
      end
    end

    describe '#age_less_than_61?' do
      it 'raises an ArgumentError when the age is not an integer' do
        expect { age_less_than_61?('61') }.to raise_error(ArgumentError)
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
