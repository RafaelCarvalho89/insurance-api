# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # Methods module
  module RiskQuestionMethods
    def validate_risk_questions_input(input)
      raise ArgumentError, 'Risk questions must be an array with size of 3' unless input.is_a?(Array) && input.size == 3
      raise ArgumentError, 'Risk questions must be an array with 0 or 1' unless input.all? { |n| [0, 1].include?(n) }
    end

    def sum_risk_questions(risk_questions)
      validate_risk_questions_input(risk_questions)

      risk_questions.sum
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end
  end
end
