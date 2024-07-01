# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/insurance_profile/services/profile_evaluator'

RSpec.describe InsuranceProfileEvaluator do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:disability_insurance_plan_evaluator) { instance_double('DisabilityInsurancePlanEvaluator') }
  let(:home_insurance_plan_evaluator) { instance_double('HomeInsurancePlanEvaluator') }
  let(:life_insurance_plan_evaluator) { instance_double('LifeInsurancePlanEvaluator') }
  let(:vehicle_insurance_plan_evaluator) { instance_double('VehicleInsurancePlanEvaluator') }

  let(:params) { { age:, income:, risk_questions:, vehicle:, house:, marital_status:, dependents: } }
  let(:plan_evaluator_params) do
    {
      validator_service:,
      disability_insurance_plan_evaluator:,
      home_insurance_plan_evaluator:,
      life_insurance_plan_evaluator:,
      vehicle_insurance_plan_evaluator:
    }
  end

  subject { described_class.new(plan_evaluator_params) }

  before do
    allow(validator_service).to receive(:call).with(params).and_return(true)
    allow(disability_insurance_plan_evaluator).to receive(:call).with(params).and_return('disability_plan')
    allow(home_insurance_plan_evaluator).to receive(:call).with(params).and_return('home_plan')
    allow(life_insurance_plan_evaluator).to receive(:call).with(params).and_return('life_plan')
    allow(vehicle_insurance_plan_evaluator).to receive(:call).with(params).and_return('vehicle_plan')
  end

  describe '#call' do
    it 'returns a hash with insurance plans' do
      expected_result = {
        auto: 'padrão',
        disability: 'inelegível',
        home: 'economico',
        life: 'padrão'
      }

      expect(subject.call(params)).to eq(expected_result)
    end

    it 'raises an ArgumentError when validator_service raises an ArgumentError' do
      allow(validator_service).to receive(:call).with(params).and_raise(ArgumentError)
      expect { subject.call(params) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError when any plan evaluator raises an ArgumentError' do
      allow(disability_insurance_plan_evaluator).to receive(:call).with(params).and_raise(ArgumentError)
      expect { subject.call(params) }.to raise_error(ArgumentError)
    end
  end
end
