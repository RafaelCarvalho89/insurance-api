# frozen_string_literal: true

# MinValidation class
class MinValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be at least #{@rule[:min]}" unless @value >= @rule[:min]
  end
end
