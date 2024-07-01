# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  OWNERSHIP_STATUS_LIST = %w[owned rented].freeze
  OWNERSHIP_STATUS = OWNERSHIP_STATUS_LIST.map { |status| [status.to_sym, status] }.to_h.freeze

  HIGHEST_INCOME = 200_000

  MARITAL_STATUS_LIST = %w[single married].freeze
  MARITAL_STATUS = MARITAL_STATUS_LIST.map { |status| [status.to_sym, status] }.to_h.freeze

  VEHICLE_INITIAL_YEAR = 1886
  VEHICLE_CURRENT_YEAR = Time.now.year
  VEHICLE_SIX_YEARS_AGO = VEHICLE_CURRENT_YEAR - 6

  module CONSTANTS
    VALIDATION_CONFIG_MAP = {
      age: [:required, :type_integer, { min: 0 }, { max: 120 }],
      house: [:required, :type_hash, { keys: [:ownership_status] }],
      income: [:required, :type_integer, { min: 0 }],
      marital_status: [:required, :type_string, { in: MARITAL_STATUS_LIST }],
      risk_questions: [:required], # TODO: :type_array_of_boolean
      user_dependents: [:required, :type_integer, { min: 0 }],
      vehicle: [:required, :type_hash, { keys: [:year] }]
    }.freeze
  end

  # Utils module
  module Utils
    def array_of_strings?(input)
      input.is_a?(Array) && input.size.positive? && input.all? do |param_name|
        param_name.is_a?(String)
      end
    end

    def build_validations(param_name_list)
      raise ArgumentError, 'param_name_list must be an array of strings' unless array_of_strings?(param_name_list)

      validation = {}

      param_name_list.each do |param_name|
        validation[param_name.to_sym] = CONSTANTS::VALIDATION_CONFIG_MAP[param_name.to_sym]
      end

      validation.freeze
    end

    # TODO: Implement
    # def array_of_boolean?(input); end
  end
end
