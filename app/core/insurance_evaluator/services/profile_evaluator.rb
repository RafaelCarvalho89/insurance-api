# frozen_string_literal: true

# InsuranceProfileEvaluator class
class InsuranceProfileEvaluator
  def initialize(params)
    @validator_service = params[:validator_service]
    @disability_insurance_plan_evaluator = params[:disability_insurance_plan_evaluator]
    @home_insurance_plan_evaluator = params[:home_insurance_plan_evaluator]
    @life_insurance_plan_evaluator = params[:life_insurance_plan_evaluator]
    @vehicle_insurance_plan_evaluator = params[:vehicle_insurance_plan_evaluator]
  end

  def call(params)
    @validator_service.call(params)

    {
      auto: @vehicle_insurance_plan_evaluator.call(params),
      home: @home_insurance_plan_evaluator.call(params),
      life: @life_insurance_plan_evaluator.call(params),
      disability: @disability_insurance_plan_evaluator.call(params)
    }
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end
end
