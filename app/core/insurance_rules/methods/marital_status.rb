# frozen_string_literal: true

# InsuranceRules::MaritalStatusMethods
module InsuranceRules
  # MaritalStatusMethods
  module MaritalStatusMethods
    def validate_marital_status_input(marital_status)
      raise ArgumentError, 'Marital status must be a string' unless marital_status.is_a?(String)

      return if MARITAL_STATUS_LIST.include?(marital_status)

      raise ArgumentError, 'Marital status must be one of the following: ' \
                           "#{MARITAL_STATUS_LIST.join(', ')}"
    end

    def married_user?(marital_status)
      validate_marital_status_input(marital_status)

      marital_status == MARITAL_STATUS[:married]
    end
  end
end
