# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/vehicle_insurance/services/plan_evaluator'

RSpec.describe VehicleInsurancePlanEvaluator do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:insurance_plan_categorizer) { instance_double('InsurancePlanCategorizer') }
  let(:eligibility_validator) { instance_double('VehicleInsuranceEligibilizer') }
  let(:risk_score_calculator) { instance_double('VehicleInsuranceRiskScorer') }

  let(:plan_evaluator_params) do
    {
      validator_service:,
      insurance_plan_categorizer:,
      eligibility_validator:,
      risk_score_calculator:
    }
  end

  subject { described_class.new(plan_evaluator_params) }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    let(:age) { 35 }
    let(:income) { 100_000 }
    let(:risk_questions) { [0, 1, 0] }
    let(:vehicle) { { year: 2024 } }
    let(:house) { { ownership_status: 'owned' } }

    let(:params) { { age:, income:, risk_questions:, vehicle:, house: } }

    context 'when any error occurs' do # rubocop:disable Metrics/BlockLength
      it 'raises an unexpected error for any reason' do
        allow(validator_service).to receive(:call).with(params).and_raise(ArgumentError)
        expect { subject.call(params) }.to raise_error(ArgumentError)
      end

      it 'raises an unexpected error for validator_service' do
        allow(validator_service).to receive(:call).with(params).and_raise(StandardError)
        expect { subject.call(params) }.to raise_error(StandardError)
      end

      it 'raises an unexpected error for eligibility_validator' do
        allow(validator_service).to receive(:call).with(params).and_return(true)
        allow(eligibility_validator).to receive(:call).with(
          income: params[:income],
          vehicle: params[:vehicle],
          house: params[:house]
        ).and_raise(StandardError)
        expect { subject.call(params) }.to raise_error(StandardError)
      end

      it 'raises an unexpected error for risk_score_calculator' do
        allow(validator_service).to receive(:call).with(params).and_return(true)
        allow(eligibility_validator).to receive(:call).with(
          income: params[:income],
          vehicle: params[:vehicle],
          house: params[:house]
        ).and_return(true)

        allow(risk_score_calculator).to receive(:call).with(
          age: params[:age],
          income: params[:income],
          vehicle: params[:vehicle],
          risk_questions: params[:risk_questions]
        ).and_raise(StandardError)
        expect { subject.call(params) }.to raise_error(StandardError)
      end

      it 'raises an unexpected error for insurance_plan_categorizer' do
        allow(validator_service).to receive(:call).with(params).and_return(true)
        allow(eligibility_validator).to receive(:call).with(
          income: params[:income],
          vehicle: params[:vehicle],
          house: params[:house]
        ).and_return(true)

        allow(risk_score_calculator).to receive(:call).with(
          age: params[:age],
          income: params[:income],
          vehicle: params[:vehicle],
          risk_questions: params[:risk_questions]
        ).and_return(2)
        allow(insurance_plan_categorizer).to receive(:call).with(2).and_raise(StandardError)
        expect { subject.call(params) }.to raise_error(StandardError)
      end
    end

    context 'when all parameters are valid' do
      it 'returns a valid insurance plan' do
        allow(validator_service).to receive(:call).with(params).and_return(true)
        allow(eligibility_validator).to receive(:call).with(
          income: params[:income],
          vehicle: params[:vehicle],
          house: params[:house]
        ).and_return(true)

        allow(risk_score_calculator).to receive(:call).with(
          age: params[:age],
          income: params[:income],
          vehicle: params[:vehicle],
          risk_questions: params[:risk_questions]
        ).and_return(2)
        allow(insurance_plan_categorizer).to receive(:call).with(2).and_return('padrão')

        expect(subject.call(params)).to eq('padrão')
      end

      it 'returns ineligível when eligibility_validator returns false' do
        allow(validator_service).to receive(:call).with(params).and_return(true)
        allow(eligibility_validator).to receive(:call).with(
          income: params[:income],
          vehicle: params[:vehicle],
          house: params[:house]
        ).and_return(false)

        expect(subject.call(params)).to eq('ineligível')
      end
    end
  end
end
