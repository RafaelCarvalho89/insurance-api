# frozen_string_literal: true

require_relative '../rule'

# RequiredValidation class
class RequiredValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} is required" if @value.nil?
  end
end
