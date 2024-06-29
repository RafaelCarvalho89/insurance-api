# frozen_string_literal: true

# InsuranceRules module
module InsuranceRules
  # VehicleMethods module
  module VehicleMethods
    INITIAL_YEAR = 1886
    CURRENT_YEAR = Time.now.year
    SIX_YEARS_AGO = CURRENT_YEAR - 6

    def validate_vehicle_year_input(vehicle_year)
      raise ArgumentError, 'Vehicle year must be an integer' unless vehicle_year.is_a?(Integer)

      return if vehicle_year.between?(INITIAL_YEAR, CURRENT_YEAR)

      raise ArgumentError, 'Vehicle year must be a between 1886 and ' \
                           "#{CURRENT_YEAR}"
    end

    def vehicle_year?(vehicle_year)
      validate_vehicle_year_input(vehicle_year)
      vehicle_year.between?(INITIAL_YEAR, CURRENT_YEAR)
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def validate_vehicle_input(vehicle)
      unless [
        vehicle.nil?,
        vehicle.is_a?(Hash) && vehicle.key?(:year) && vehicle_year?(vehicle[:year])
      ].any?
        raise ArgumentError, 'Vehicle must be a hash with a key year of between 1886 and ' \
                             "#{CURRENT_YEAR}"
      end
    end

    def vehicle?(vehicle)
      validate_vehicle_input(vehicle)
      vehicle.is_a?(Hash) && vehicle_year?(vehicle[:year])
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end

    def vehicle_more_than_5_years?(vehicle_year)
      validate_vehicle_year_input(vehicle_year)
      vehicle_year.between?(INITIAL_YEAR, SIX_YEARS_AGO)
    rescue ArgumentError => e
      raise ArgumentError, e.message
    end
  end
end
