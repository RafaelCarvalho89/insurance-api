# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/life_insurance/services/risk_scorer'

RSpec.describe LifeInsuranceRiskScorer do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:validator_params) { { validator_service: } }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    context 'when any error occurs' do # rubocop:disable Metrics/BlockLength
      let(:invalid_common_list) { [true, false, 0.0, 1.0, 'any_string', 1..1885, {}, []] }
      let(:invalid_risk_questions_array_list) { [[1], [1, 0], [0, 1, 0, 1], [1, 2, 3]] }

      let(:invalid_age_list) { invalid_common_list + [nil] }
      let(:invalid_income_list) { invalid_common_list + [nil] }
      let(:invalid_marital_status_list) { invalid_common_list + [nil] }
      let(:invalid_user_dependents_list) { invalid_common_list + [nil] }
      let(:invalid_risk_questions_list) { invalid_common_list + [nil, invalid_risk_questions_array_list] }

      let(:age) { 35 }
      let(:income) { 100_000 }
      let(:marital_status) { 'married' }
      let(:dependents) { 3 }
      let(:risk_questions) { [0, 1, 1] }

      let(:params) do
        {
          age:,
          income:,
          marital_status:,
          dependents:,
          risk_questions:
        }
      end

      it 'raise an error for age is invalid type' do
        invalid_age_list.each do |invalid_age|
          params[:age] = invalid_age
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }
            .to raise_error(ArgumentError, 'Age must be an integer')
        end
      end

      it 'raise an error for income is invalid type' do
        invalid_income_list.each do |invalid_income|
          params[:income] = invalid_income
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }.to raise_error(ArgumentError)
        end
      end

      it 'raise an error for marital_status is invalid type' do
        invalid_marital_status_list.each do |invalid_marital_status|
          params[:marital_status] = invalid_marital_status
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }.to raise_error(ArgumentError)
        end
      end

      it 'raise an error for user_dependents is invalid type' do
        invalid_user_dependents_list.each do |invalid_user_dependents|
          params[:dependents] = invalid_user_dependents
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }
            .to raise_error(ArgumentError)
        end
      end

      it 'raise an error for risk_questions is invalid type' do
        invalid_risk_questions_list.each do |invalid_risk_questions|
          params[:risk_questions] = invalid_risk_questions
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }
            .to raise_error(ArgumentError)
        end
      end

      it 'raise an unexpected error' do
        allow(validator_service).to receive(:call).with(params).and_raise(StandardError)
        risk_scorer = described_class.new(validator_params)
        expect { risk_scorer.call(params) }.to raise_error(StandardError)
      end
    end

    context 'whe provided params is valid and risk_score is calculated' do
      it 'return a valid risk_score' do
        params = {
          age: 30, # -1 point
          income: 100_000, # 0 point
          marital_status: 'married', # -1 point
          dependents: 0, # 0 point
          risk_questions: [0, 0, 0] # -2 point
        }

        # expected risk_score = -2 points

        allow(validator_service).to receive(:call).with(params).and_return(true)
        risk_scorer = described_class.new(validator_params)
        expect(risk_scorer.call(params)).to eq(-2)
      end
    end
  end
end
