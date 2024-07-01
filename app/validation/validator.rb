# frozen_string_literal: true

require_relative 'rules/hash_keys'
require_relative 'rules/in'
require_relative 'rules/max'
require_relative 'rules/min'
require_relative 'rules/required'
require_relative 'rules/type_hash'
require_relative 'rules/type_integer'
require_relative 'rules/type_string'

# Validator class
class Validator
  RULES_MAPPING = {
    required: RequiredValidation,
    type_integer: TypeIntegerValidation,
    type_string: TypeStringValidation,
    min: MinValidation,
    max: MaxValidation,
    in: InValidation,
    type_hash: TypeHashValidation,
    hash_keys: HashKeysValidation
  }.freeze

  def initialize(validations)
    @validations = validations
  end

  def call(params)
    @validations.each do |key, rule_list|
      rule_list.each do |rule|
        validate_rule(key, rule, params)
      end
    end
  end

  private

  def valid_rule?(rule)
    case rule
    when Symbol
      RULES_MAPPING.key?(rule)
    when Hash
      RULES_MAPPING.key?(rule.keys.first)
    else
      false
    end
  end

  def validate_rule(key, rule, params)
    raise ArgumentError, "#{rule} validation is not supported" unless valid_rule?(rule)

    case rule
    when Symbol
      RULES_MAPPING[rule].new.validate(params[key])
    when Hash
      rule_name, rule_options = rule.first
      RULES_MAPPING[rule_name].new(rule_options).validate(params[key])
    end
  end
end
