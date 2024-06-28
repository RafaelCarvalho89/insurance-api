# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/age'

module InsuranceRules
  RSpec.describe 'Age Methods age_zero_or_more?' do
    include AgeMethods

    describe '#age_zero_or_more?' do
      context 'when the age is zero or more' do
        it 'returns true' do
          expect(age_zero_or_more?(0)).to be true
        end
      end

      context 'when the age is negative' do
        it 'returns false' do
          expect(age_zero_or_more?(-1)).to be false
        end
      end

      context 'when the age is not an integer' do
        it 'raises an ArgumentError' do
          expect { age_zero_or_more?('0') }.to raise_error(ArgumentError)
        end
      end
    end
  end

  RSpec.describe 'Age Methods age_less_than_30?' do
    include AgeMethods

    describe '#age_less_than_30?' do
      context 'when the age is less than 30' do
        it 'returns true' do
          expect(age_less_than_30?(25)).to be true
        end
      end

      context 'when the age is greater than 30' do
        it 'returns false' do
          expect(age_less_than_30?(31)).to be false
        end
      end

      context 'when the age is not an integer' do
        it 'raises an ArgumentError' do
          expect { age_less_than_30?('25') }.to raise_error(ArgumentError)
        end
      end
    end
  end

  RSpec.describe 'Age Methods age_between_30_and_40?' do
    include AgeMethods

    describe '#age_between_30_and_40?' do
      context 'when the age is not an integer' do
        it 'raises an ArgumentError' do
          expect { age_between_30_and_40?('35') }.to raise_error(ArgumentError)
        end
      end

      context 'when the age is less than 30' do
        it 'returns false' do
          expect(age_between_30_and_40?(29)).to be false
        end
      end

      context 'when the age is greater than 40' do
        it 'returns false' do
          expect(age_between_30_and_40?(41)).to be false
        end
      end

      context 'when the age is between 30 and 40' do
        it 'returns true' do
          expect(age_between_30_and_40?(35)).to be true
        end
      end
    end
  end
end
