# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # Methods module
  module AgeMethods
    def age_zero_or_more?(age)
      raise ArgumentError unless age.is_a?(Integer)

      age >= 0
    rescue ArgumentError
      raise ArgumentError, 'Age must be an integer'
    end

    def age_less_than_30?(age)
      raise ArgumentError unless age.is_a?(Integer) && age_zero_or_more?(age)

      age < 30
    rescue ArgumentError
      raise ArgumentError, 'Age must be an positive integer'
    end

    def age_between_30_and_40?(age)
      raise ArgumentError unless age.is_a?(Integer) && age_zero_or_more?(age)

      age.between?(30, 40)
    rescue ArgumentError
      raise ArgumentError, 'Age must be an positive integer'
    end

    def age_less_than_61?(age)
      raise ArgumentError unless age.is_a?(Integer) && age_zero_or_more?(age)

      age < 61
    rescue ArgumentError
      raise ArgumentError, 'Age must be an positive integer'
    end
  end
end
