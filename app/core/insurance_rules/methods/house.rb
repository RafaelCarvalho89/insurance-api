# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # HouseMethods module
  module HouseMethods
    def ownership_status?(ownership_status)
      OWNERSHIP_STATUS_LIST.include?(ownership_status)
    end

    def validate_house_input(house)
      unless [
        house.nil?,
        house.is_a?(Hash) && house.key?(:ownership_status) && ownership_status?(house[:ownership_status])
      ].any?
        raise ArgumentError
      end
    rescue ArgumentError
      raise ArgumentError, 'House must be a hash with a key ownership_status of owned or rented'
    end

    def house?(house)
      validate_house_input(house)
      house.is_a?(Hash) && ownership_status?(house[:ownership_status])
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def rented?(ownership_status)
      raise ArgumentError unless ownership_status?(ownership_status)

      ownership_status == OWNERSHIP_STATUS[:rented]
    rescue ArgumentError
      raise ArgumentError, 'Ownership status must be a valid status of owned or rented'
    end
  end
end
