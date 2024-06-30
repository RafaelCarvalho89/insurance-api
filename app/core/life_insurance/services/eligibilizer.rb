# frozen_string_literal: true

require_relative '../../insurance_rules/methods/income'
require_relative '../../insurance_rules/methods/vehicle'
require_relative '../../insurance_rules/methods/house'
require_relative '../../insurance_rules/methods/age'

# LifeInsuranceEligibilizer class
class LifeInsuranceEligibilizer
  include InsuranceRules::IncomeMethods
  include InsuranceRules::VehicleMethods
  include InsuranceRules::HouseMethods
  include InsuranceRules::AgeMethods

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @income = params[:income]
    @vehicle = params[:vehicle]
    @house = params[:house]
    @age = params[:age]

    condition_list.all?
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def condition_list
    [
      income?(@income),
      vehicle?(@vehicle),
      house?(@house),
      age_less_than_61?(@age)
    ]
  end
end
