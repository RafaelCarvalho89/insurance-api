# frozen_string_literal: true

# VehicleInsurancePlanEvaluator class
class VehicleInsurancePlanEvaluator
  def initialize(params)
    @validator_service = params[:validator_service]
    @insurance_plan_categorizer = params[:insurance_plan_categorizer]
    @eligibility_validator = params[:eligibility_validator]
    @risk_score_calculator = params[:risk_score_calculator]
  end

  def call(params)
    @validator_service.call(params)

    elilibility_param = { income: params[:income], vehicle: params[:vehicle], house: params[:house] }

    return 'ineligível' unless eligibility?(elilibility_param)

    risk_score = @risk_score_calculator.call(
      age: params[:age],
      income: params[:income],
      vehicle: params[:vehicle],
      risk_questions: params[:risk_questions]
    )

    @insurance_plan_categorizer.call(risk_score)
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def eligibility?(params)
    @eligibility_validator.call(
      income: params[:income],
      vehicle: params[:vehicle],
      house: params[:house]
    )
  end
end
