# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # Methods module
  module UserDependentsMethods
    def validate_user_dependents_input(user_dependents)
      raise ArgumentError, 'User dependents must be an integer' unless user_dependents.is_a?(Integer)
      raise ArgumentError, 'User dependents must be a non-negative integer' unless user_dependents >= 0
    end

    def user_dependents?(user_dependents)
      validate_user_dependents_input(user_dependents)
      user_dependents.positive?
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end
  end
end
