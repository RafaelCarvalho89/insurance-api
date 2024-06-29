# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/user_dependents'

module InsuranceRules
  RSpec.describe UserDependentsMethods do
    include UserDependentsMethods

    describe '# validate_user_dependents_input?' do
      it 'raises an ArgumentError when the user_dependents is not an integer or is negative' do
        expect { validate_user_dependents_input('25') }.to raise_error(ArgumentError)
        expect { validate_user_dependents_input(-1) }.to raise_error(ArgumentError)
      end
    end

    describe '# user_dependents?' do
      it 'raises an ArgumentError when the user_dependents is not an integer or is negative' do
        expect { user_dependents?('25') }.to raise_error(ArgumentError)
        expect { user_dependents?(-1) }.to raise_error(ArgumentError)
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
