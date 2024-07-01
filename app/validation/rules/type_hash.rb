# frozen_string_literal: true

require_relative '../rule'

# TypeHashValidation class
class TypeHashValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be a hash" unless @value.is_a?(Hash)
  end
end
