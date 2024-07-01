# frozen_string_literal: true

require_relative '../rule'

# MinValidation class
class MinValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be at least #{@rule[:min]}" unless @value >= @rule[:min]
  end
end
