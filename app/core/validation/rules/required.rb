# frozen_string_literal: true

# RequiredValidation class
class RequiredValidation < ValidationRule
  def validate
    raise ArgumentError, "#{@key} is required" if @value.nil?
  end
end
