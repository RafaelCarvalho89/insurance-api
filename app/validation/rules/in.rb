# frozen_string_literal: true

require_relative '../rule'

# InValidation class
class InValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} must be one of #{@rule[:in]}" unless @rule[:in].include?(@value)
  end
end
