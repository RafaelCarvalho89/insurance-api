# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/income'

module InsuranceRules
  RSpec.describe IncomeMethods do # rubocop:disable Metrics/BlockLength
    include IncomeMethods

    describe '# validate_income_input' do
      it 'raises an ArgumentError when the income is not an integer or is negative' do
        expect { validate_income_input('25') }.to raise_error(ArgumentError)
        expect { validate_income_input(-1) }.to raise_error(ArgumentError)
      end
    end

    describe '# income?' do
      it 'raises an ArgumentError when the income is not an integer or is negative' do
        expect { income?('25') }.to raise_error(ArgumentError)
      end

      it 'returns true when the income is more than 0' do
        expect(income?(1)).to be true
      end

      it 'returns false when the income is 0' do
        expect(income?(0)).to be false
      end
    end

    describe '# income_more_than_200_000?' do
      it 'raises an ArgumentError when the income is not an integer or is negative' do
        expect { income_more_than_200_000?('25') }.to raise_error(ArgumentError)
      end

      it 'returns true when the income is more than 200_000' do
        expect(income_more_than_200_000?(200_001)).to be true
      end

      it 'returns false when the income not is more than 200_000' do
        expect(income_more_than_200_000?(200_000)).to be false
      end
    end
  end
end
