# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # HouseMethods module
  module HouseMethods
    def ownership_status?(ownership_status)
      %w[owned rented].include?(ownership_status)
    end

    def house?(house)
      raise ArgumentError unless house.is_a?(Hash) && ownership_status?(house[:ownership_status]) || house.nil?

      house.is_a?(Hash) && ownership_status?(house[:ownership_status])
    rescue ArgumentError
      raise ArgumentError, 'House must be a hash with a valid ownership_status'
    end

    def rented?(ownership_status)
      raise ArgumentError unless ownership_status?(ownership_status)

      ownership_status == 'rented'
    rescue ArgumentError
      raise ArgumentError, 'Ownership status must be a valid status'
    end
  end
end
