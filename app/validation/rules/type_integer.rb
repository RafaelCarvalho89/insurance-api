# frozen_string_literal: true

require_relative '../rule'

# TypeIntegerValidation class
class TypeIntegerValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be an integer" unless @value.is_a?(Integer)
  end
end
