# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/insurance_evaluator/services/plan_categorizer'

RSpec.describe InsurancePlanCategorizer do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:validator_params) { { validator_service: } }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    context 'when any error occurs' do
      let(:invalid_score_list) { [nil, true, false, 0.1, 1.1, 'any_string', {}, []] }

      it 'raise an error for score is invalid type' do
        invalid_score_list.each do |invalid_score|
          params = { score: invalid_score }
          allow(validator_service).to receive(:call).with(params).and_return(false)
          expect { described_class.new(validator_params).call(params) }
            .to raise_error(ArgumentError, 'Score must be an integer')
        end
      end

      it 'raise an unexpected error' do
        params = { score: '1' }
        allow(validator_service).to receive(:call).with(params).and_raise(StandardError)
        expect { described_class.new(validator_params).call(params) }.to raise_error(StandardError)
      end
    end

    context 'when score is between 0 or less' do
      it 'returns economic plan' do
        [-7..0].sample.each do |score|
          params = { score: }
          allow(validator_service).to receive(:call).with(params).and_return(true)
          plan_categorizer = described_class.new(validator_params)
          result = plan_categorizer.call(params)
          expect(result).to eq('econômico')
        end
      end
    end

    context 'when score is between 1 and 2' do
      it 'returns standard plan' do
        [1..2].sample.each do |score|
          params = { score: }
          allow(validator_service).to receive(:call).with(params).and_return(true)
          plan_categorizer = described_class.new(validator_params)
          result = plan_categorizer.call(params)
          expect(result).to eq('padrão')
        end
      end
    end

    context 'when score is between 2 or more' do
      it 'returns standard plan' do
        [3..9].sample.each do |score|
          params = { score: }
          allow(validator_service).to receive(:call).with(params).and_return(true)
          plan_categorizer = described_class.new(validator_params)
          result = plan_categorizer.call(params)
          expect(result).to eq('avançado')
        end
      end
    end
  end

  describe '#categorize' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validator_params) }

    context 'when any error occurs' do
      let(:invalid_score_list) { [nil, true, false, 0.1, 1.1, 'any_string', {}, []] }

      it 'raise an error for score is invalid type' do
        invalid_score_list.each do |invalid_score|
          expect { subject.send(:categorize, score: invalid_score) }
            .to raise_error(ArgumentError, 'Score must be an integer')
        end
      end
    end

    context 'when score is between 0 or less' do
      it 'returns econômico of categorize private method' do
        categorize_method = subject.send(:categorize, 0)
        expect(categorize_method).to eq('econômico')
      end
    end

    context 'when score is between 1 and 2' do
      it 'returns padrão of categorize private method' do
        categorize_method = subject.send(:categorize, 1)
        expect(categorize_method).to eq('padrão')
      end
    end

    context 'when score is between 2 or more' do
      it 'returns avançado of categorize private method' do
        categorize_method = subject.send(:categorize, 3)
        expect(categorize_method).to eq('avançado')
      end
    end
  end
end
