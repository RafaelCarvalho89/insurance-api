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
end
