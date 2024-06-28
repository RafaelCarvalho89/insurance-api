# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/user_dependents'

module InsuranceRules
  RSpec.describe 'User Dependents Methods user_dependents_zero_or_more?' do
    include UserDependentsMethods

    context '# user_dependents_zero_or_more?' do
      it 'raises an ArgumentError when the user_dependents is not an integer' do
        expect { user_dependents_zero_or_more?('25') }.to raise_error(ArgumentError)
      end

      it 'returns true when the user_dependents is zero or more' do
        expect(user_dependents_zero_or_more?(0)).to be true
      end

      it 'returns false when the user_dependents is negative' do
        expect(user_dependents_zero_or_more?(-1)).to be false
      end
    end

    context '# user_dependents?' do
      it 'raises an ArgumentError when the user_dependents is not an integer' do
        expect { user_dependents?('25') }.to raise_error(ArgumentError)
      end

      it 'returns true when the user has dependents' do
        expect(user_dependents?(1)).to be true
      end

      it 'returns false when the user does not have dependents' do
        expect(user_dependents?(0)).to be false
      end
    end
  end
end
