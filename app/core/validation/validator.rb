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
  RULE_CLASS_LIST = %i[Symbol Hash].freeze

  RULE_CLASS_MAPPING = RULE_CLASS_LIST.map { |class_name| [class_name.to_sym, class_name] }.to_h.freeze

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
    @validations.each_value do |rule_list|
      validate_key_rules(rule_list)
    end
  end

  def valid_rule?(rule)
    case rule.class.to_s
    when 'Symbol'
      RULES_MAPPING.key?(rule)
    when 'Hash'
      RULES_MAPPING.key?(rule.keys.first)
    else
      false
    end
  end

  private

  def validate_key_rules(rule_list)
    rule_list.each do |rule|
      raise ArgumentError, "#{rule} validation is not supported" unless valid_rule?(rule)
    end
  end
end
