# frozen_string_literal: true

# HashKeysValidation class
class HashKeysValidation < ValidationRule
  def validate
    @rule[:keys].each do |key|
      raise ArgumentError, "#{key} is required in the hash" unless @value.key?(key)
    end
  end
end
