# frozen_string_literal: true

# TypeStringValidation class
class TypeStringValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be a string" unless @value.is_a?(String)
  end
end
