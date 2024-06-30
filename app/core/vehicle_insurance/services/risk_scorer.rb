# frozen_string_literal: true

require_relative '../../insurance_rules/methods/age'
require_relative '../../insurance_rules/methods/income'
require_relative '../../insurance_rules/methods/vehicle'
require_relative '../../insurance_rules/methods/risk_question'

# RiskScorer class
class VehicleInsuranceRiskScorer
  include InsuranceRules::AgeMethods
  include InsuranceRules::IncomeMethods
  include InsuranceRules::VehicleMethods
  include InsuranceRules::RiskQuestionMethods

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @age = params[:age]
    @income = params[:income]
    @vehicle = params[:vehicle]
    @base_score = sum_risk_questions(params[:risk_questions])

    calculate_risk_score(config_list)
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def config_list
    [
      { condition: age_less_than_30?(@age), point: -2 },
      { condition: age_between_30_and_40?(@age), point: -1 },
      { condition: income_more_than_200_000?(@income), point: -1 },
      { condition: vehicle?(@vehicle) && vehicle_more_than_5_years?(@vehicle[:year]), point: +1 }
    ]
  end

  def calculate_risk_score(config_list)
    @risk_score = @base_score
    config_list.each do |config|
      @risk_score += config[:point] if config[:condition]
    end

    @risk_score
  end
end
