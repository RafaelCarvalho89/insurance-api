# frozen_string_literal: true

# InsurancePlanCategorizer class
class InsurancePlanCategorizer
  ECONOMIC_LIMIT = 0
  STANDARD_LIMIT = 2

  attr_reader :validator_service

  def initialize(params)
    @validator_service = params[:validator_service]
  end

  def call(params)
    validator_service.call(params)

    @score = params[:score]

    categorize(@score)
  rescue ArgumentError => e
    raise ArgumentError, e.message
  end

  private

  def categorize(score)
    raise ArgumentError, 'Score must be an integer' unless score.is_a?(Integer)

    case score
    when ..ECONOMIC_LIMIT
      'econômico'
    when (ECONOMIC_LIMIT + 1)..STANDARD_LIMIT
      'padrão'
    else
      'avançado'
    end
  end
end
