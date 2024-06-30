# frozen_string_literal: true

# ValidationRule class
class ValidationRule
  attr_reader :key, :value, :rule

  def initialize(key, value, rule)
    @key = key
    @value = value
    @rule = rule
  end

  def validate
    raise NotImplementedError, 'Subclasses must implement the validate method'
  end
end
