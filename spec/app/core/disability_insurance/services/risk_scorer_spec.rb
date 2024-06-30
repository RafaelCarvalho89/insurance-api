# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/disability_insurance/services/risk_scorer'

RSpec.describe DisabilityInsuranceRiskScorer do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:validator_params) { { validator_service: } }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    context 'when any error occurs' do # rubocop:disable Metrics/BlockLength
      let(:this_year) { Date.today.year }
      let(:next_year) { this_year + 1 }
      let(:invalid_common_list) { [true, false, 0.0, 1.0, 'any_string', 1..1885, {}, []] }
      let(:invalid_house_ownership_status_list) { invalid_common_list + [nil] }
      let(:invalid_risk_questions_array_list) { [[1], [1, 0], [0, 1, 0, 1], [1, 2, 3]] }

      let(:invalid_age_list) { invalid_common_list + [nil] }
      let(:invalid_house_list) do
        invalid_common_list + [{ ownership_status: invalid_house_ownership_status_list.sample }]
      end
      let(:invalid_income_list) { invalid_common_list + [nil] }
      let(:invalid_marital_status_list) { invalid_common_list + [nil] }
      let(:invalid_user_dependents_list) { invalid_common_list + [nil] }
      let(:invalid_risk_questions_list) { invalid_common_list + [nil, invalid_risk_questions_array_list] }

      let(:age) { 35 }
      let(:house) { { ownership_status: 'owned' } }
      let(:income) { 100_000 }
      let(:marital_status) { 'married' }
      let(:dependents) { 3 }
      let(:risk_questions) { [0, 1, 1] }

      let(:params) do
        {
          age:,
          house:,
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

      it 'raise an error for house ownership_status is invalid type' do
        invalid_house_ownership_status_list.each do |invalid_house_ownership_status|
          params[:house] = { ownership_status: invalid_house_ownership_status }
          allow(validator_service).to receive(:call).with(params).and_return(false)
          risk_scorer = described_class.new(validator_params)
          expect { risk_scorer.call(params) }.to raise_error(ArgumentError)
        end
      end

      it 'raise an error for house is invalid type' do
        invalid_house_list.each do |invalid_house|
          params[:house] = invalid_house
          allow(validator_service).to receive(:call).with(params).and_return(false)
          expect { described_class.new(validator_params).call(params) }
            .to raise_error(ArgumentError)
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
          house: { ownership_status: 'rented' }, # +1 point
          income: 100_000, # 0 point
          marital_status: 'married', # -1 point
          dependents: 3, # +1 point
          risk_questions: [1, 1, 1] # +3 point
        }

        # expected risk_score = 4 points

        allow(validator_service).to receive(:call).with(params).and_return(true)
        risk_scorer = described_class.new(validator_params)
        expect(risk_scorer.call(params)).to eq(3)
      end
    end
  end
end
