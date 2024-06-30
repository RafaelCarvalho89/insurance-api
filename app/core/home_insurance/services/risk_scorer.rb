# frozen_string_literal: true

require_relative '../../insurance_rules/methods/age'
require_relative '../../insurance_rules/methods/house'
require_relative '../../insurance_rules/methods/income'
require_relative '../../insurance_rules/methods/risk_question'

# HomeInsuranceRiskScorer class
class HomeInsuranceRiskScorer
  include InsuranceRules::AgeMethods
  include InsuranceRules::HouseMethods
  include InsuranceRules::IncomeMethods
  include InsuranceRules::RiskQuestionMethods

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @age = params[:age]
    @house = params[:house]
    @income = params[:income]
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
      { condition: house?(@house) && rented?(@house[:ownership_status]), point: +1 }
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
