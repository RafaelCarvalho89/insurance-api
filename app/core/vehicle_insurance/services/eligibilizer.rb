# frozen_string_literal: true

require_relative '../../insurance_rules/methods/income'
require_relative '../../insurance_rules/methods/vehicle'
require_relative '../../insurance_rules/methods/house'

# VehicleInsuranceEligibilizer class
class VehicleInsuranceEligibilizer
  include InsuranceRules::IncomeMethods
  include InsuranceRules::VehicleMethods
  include InsuranceRules::HouseMethods

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @income = params[:income]
    @vehicle = params[:vehicle]
    @house = params[:house]

    condition_list.all?
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def condition_list
    [
      income?(@income),
      vehicle?(@vehicle),
      house?(@house)
    ]
  end
end
