# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/disability_insurance/services/plan_evaluator'

RSpec.describe DisabilityInsurancePlanEvaluator do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:validator_params) { { validator_service: } }

  let(:insurance_plan_categorizer) { instance_double('InsurancePlanCategorizer') }
  let(:insurance_plan_categorizer_params) { { validator_service: } }

  let(:eligibility_validator) { instance_double('DisabilityInsuranceEligibilizer') }
  let(:eligibility_validator_params) { { insurance_plan_categorizer: } }

  let(:risk_score_calculator) { instance_double('DisabilityInsuranceRiskScorer') }
  let(:risk_score_calculator_params) { { risk_score_calculator: } }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    context 'when any error occurs' do # rubocop:disable Metrics/BlockLength
      let(:this_year) { Date.today.year }
      let(:next_year) { this_year + 1 }

      let(:invalid_common_list) { [true, false, 0.0, 1.0, 'any_string', {}, []] }

      let(:invalid_vehicle_year_list) { invalid_common_list + [..1885, next_year.., nil] }
      let(:invalid_house_ownership_status_list) { invalid_common_list + [nil] }

      let(:invalid_age_list) { invalid_common_list + [nil] }
      let(:invalid_income_list) { invalid_common_list + [nil] }
      let(:invalid_risk_questions_list) { invalid_common_list + [nil] }
      let(:invalid_vehicle_list) { invalid_common_list + [{ year: invalid_vehicle_year_list.sample }] }
      let(:invalid_house_list) do
        invalid_common_list + [{ ownership_status: invalid_house_ownership_status_list.sample }]
      end
      let(:invalid_marital_status_list) { invalid_common_list + [nil] }
      let(:invalid_dependents_list) { invalid_common_list + [nil] }

      let(:age) { 35 }
      let(:income) { 100_000 }
      let(:risk_questions) { [] }
      let(:vehicle) { { year: 2024 } }
      let(:house) { { ownership_status: 'owned' } }
      let(:marital_status) { 'single' }
      let(:dependents) { 0 }

      subject { plan_evaluator.call(params) }

      let(:params) { { age:, income:, risk_questions:, vehicle:, house:, marital_status:, dependents: } }

      it 'raise an unexpected error for validator_service' do
        allow(validator_service).to receive(:call).with(params:).and_raise(StandardError)
        expect { subject }.to raise_error(StandardError)
      end

      it 'raise an unexpected error for insurance_plan_categorizer' do
        allow(insurance_plan_categorizer).to receive(:call).with(params:).and_raise(StandardError)
        expect { subject }.to raise_error(StandardError)
      end

      it 'raise an unexpected error for eligibility_validator' do
        params = { age:, income:, vehicle:, house: }
        allow(eligibility_validator).to receive(:call).with(params).and_raise(StandardError)
        expect { subject }.to raise_error(StandardError)
      end

      it 'raise an unexpected error for risk_score_calculator' do
        params = { age:, income:, risk_questions:, house:, marital_status:, dependents: }
        allow(risk_score_calculator).to receive(:call).with(params).and_raise(StandardError)
        expect { subject }.to raise_error(StandardError)
      end

      it 'raise an unexpected error' do
        params = { age:, income:, risk_questions:, vehicle:, house:, marital_status:, dependents: }
        allow(validator_service).to receive(:call).with(params).and_return(false)
        allow(insurance_plan_categorizer).to receive(:call).with(params).and_return('ineligível')
        allow(eligibility_validator).to receive(:call).with(params).and_return(false)
        allow(risk_score_calculator).to receive(:call).with(params).and_return(0)
        expect { subject }.to raise_error(StandardError)
      end
    end
  end
end
