# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # Methods module
  module UserDependentsMethods
    def user_dependents_zero_or_more?(user_dependents)
      raise ArgumentError unless user_dependents.is_a?(Integer)

      user_dependents >= 0
    rescue ArgumentError
      raise ArgumentError, 'User dependents must be an integer'
    end

    def user_dependents?(user_dependents)
      raise ArgumentError unless user_dependents.is_a?(Integer)

      user_dependents.positive?
    rescue ArgumentError
      raise ArgumentError, 'User dependents must be an integer'
    end
  end
end
