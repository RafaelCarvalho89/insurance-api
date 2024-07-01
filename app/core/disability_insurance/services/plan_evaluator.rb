# frozen_string_literal: true

# DisabilityInsurancePlanEvaluator class
class DisabilityInsurancePlanEvaluator
  attr_reader :validator_service, :insurance_plan_categorizer, :eligibility_validator, :risk_score_calculator

  def initialize(params)
    @validator_service = params[:validator_service]
    @insurance_plan_categorizer = params[:insurance_plan_categorizer]
    @eligibility_validator = params[:eligibility_validator]
    @risk_score_calculator = params[:risk_score_calculator]
  end

  def call(params)
    validator_service.call(params)

    if eligibility?(params)
      @risk_score = calculate_risk_score(params)
      @insurance_plan = categorize_insurance_plan(@risk_score)
    else
      @insurance_plan = 'ineligível'
    end
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def eligibility?(params)
    @eligibility_validator.validate({
                                      income: params['income'],
                                      vehicle: params['vehicle'],
                                      house: params['house'],
                                      age: params['age']
                                    })
  end

  def calculate_risk_score(params)
    @risk_score_calculator.calculate({
                                       age: params['age'],
                                       income: params['income'],
                                       risk_questions: params['risk_questions'],
                                       vehicle: params['vehicle'],
                                       house: params['house'],
                                       marital_status: params['marital_status'],
                                       dependents: params['dependents']
                                     })
  end

  def categorize_insurance_plan(risk_score)
    @insurance_plan_categorizer.categorize(risk_score)
  end
end
