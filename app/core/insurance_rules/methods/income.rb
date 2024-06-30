# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # IncomeMethods module
  module IncomeMethods
    def validate_income_input(income)
      raise ArgumentError, 'Income must be an integer' unless income.is_a?(Integer)
      raise ArgumentError, 'Income must be a non-negative integer' unless income >= 0
    end

    def income?(income)
      validate_income_input(income)
      income.positive?
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def income_more_than_200_000?(income)
      validate_income_input(income)
      income > HIGHEST_INCOME
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end
  end
end
