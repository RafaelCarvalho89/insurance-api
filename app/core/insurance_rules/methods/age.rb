# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # Methods module
  module AgeMethods
    def validate_age_input(age)
      raise ArgumentError, 'Age must be an integer' unless age.is_a?(Integer)
      raise ArgumentError, 'Age must be an non-negative integer' unless age >= 0
    end

    def age_less_than_30?(age)
      validate_age_input(age)
      age < 30
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def age_between_30_and_40?(age)
      validate_age_input(age)
      age.between?(30, 40)
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def age_less_than_61?(age)
      validate_age_input(age)
      age < 61
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end
  end
end
