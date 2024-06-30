# frozen_string_literal: true

require_relative '../../insurance_rules/methods/age'
require_relative '../../insurance_rules/methods/income'
require_relative '../../insurance_rules/methods/marital_status'
require_relative '../../insurance_rules/methods/user_dependents'
require_relative '../../insurance_rules/methods/risk_question'

# RiskScorer class
class LifeInsuranceRiskScorer
  include InsuranceRules::AgeMethods
  include InsuranceRules::IncomeMethods
  include InsuranceRules::MaritalStatusMethods
  include InsuranceRules::UserDependentsMethods
  include InsuranceRules::RiskQuestionMethods

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @age = params[:age]
    @income = params[:income]
    @marital_status = params[:marital_status]
    @user_dependents = params[:dependents]
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
      { condition: married_user?(@marital_status), point: -1 },
      { condition: user_dependents?(@user_dependents), point: +1 }
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
