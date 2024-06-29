# frozen_string_literal: true

# MaxValidation class
class MaxValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be at most #{@rule[:max]}" unless @value <= @rule[:max]
  end
end
