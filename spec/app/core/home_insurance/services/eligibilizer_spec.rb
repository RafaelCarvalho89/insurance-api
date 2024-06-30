# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../../app/core/home_insurance/services/eligibilizer'

RSpec.describe HomeInsuranceEligibilizer do # rubocop:disable Metrics/BlockLength
  let(:validator_service) { instance_double('Validator') }
  let(:validator_params) { { validator_service: } }

  describe '#call' do # rubocop:disable Metrics/BlockLength
    context 'when any error occurs' do # rubocop:disable Metrics/BlockLength
      let(:this_year) { Date.today.year }
      let(:next_year) { this_year + 1 }
      let(:invalid_common_list) { [true, false, 0.0, 1.0, 'any_string', 1..1885, {}, []] }
      let(:invalid_income_list) { invalid_common_list + [nil] }
      let(:invalid_vehicle_year_list) { invalid_common_list + [next_year.., nil] }
      let(:invalid_vehicle_list) { invalid_common_list + [{ year: invalid_vehicle_year_list.sample }] }
      let(:invalid_house_ownership_status_list) { invalid_common_list + [nil] }
      let(:invalid_house_list) do
        invalid_common_list + [{ ownership_status: invalid_house_ownership_status_list.sample }]
      end

      it 'raise an error for income is invalid type' do
        invalid_income_list.each do |invalid_income|
          params = { income: invalid_income, vehicle: { year: 2024 }, house: nil }
          allow(validator_service).to receive(:call).with(params).and_return(false)
          eligibilizer = described_class.new(validator_params)
          expect { eligibilizer.call(params) }.to raise_error(ArgumentError, 'Income must be an integer')
        end
      end

      it 'raise an error for vehicle is invalid type' do
        invalid_vehicle_list.each do |invalid_vehicle|
          params = { income: 1, vehicle: invalid_vehicle, house: { ownership_status: 'owned' } }
          allow(validator_service).to receive(:call).with(params).and_return(false)
          eligibilizer = described_class.new(validator_params)
          expect { eligibilizer.call(params) }
            .to raise_error(ArgumentError)
        end
      end

      it 'raise an error for house is invalid type' do
        invalid_house_list.each do |invalid_house|
          params = { income: 1, vehicle: { year: 2024 }, house: invalid_house }
          allow(validator_service).to receive(:call).with(params).and_return(false)
          eligibilizer = described_class.new(validator_params)
          expect { eligibilizer.call(params) }
            .to raise_error(ArgumentError)
        end
      end

      it 'raise an unexpected error' do
        params = { income: 1, vehicle: { year: 2024 }, house: { ownership_status: 'owned' } }
        allow(validator_service).to receive(:call).with(params).and_raise(StandardError)
        eligibilizer = described_class.new(validator_params)
        expect { eligibilizer.call(params) }.to raise_error(StandardError)
      end
    end

    context 'when provided params result in false' do # rubocop:disable Metrics/BlockLength
      it 'returns false for income is 0' do
        params = { income: 0, vehicle: { year: 2024 }, house: nil }
        allow(validator_service).to receive(:call).with(params).and_return(true)

        eligibilizer = described_class.new(validator_params)
        result = eligibilizer.call(params)

        expect(result).to eq(false)
      end

      it 'returns false for vehicle is nil' do
        params = { income: 1, vehicle: nil, house: { ownership_status: 'owned' } }
        allow(validator_service).to receive(:call).with(params).and_return(true)

        eligibilizer = described_class.new(validator_params)
        result = eligibilizer.call(params)

        expect(result).to eq(false)
      end

      it 'returns false for house is nil' do
        params = { income: 1, vehicle: { year: 2024 }, house: nil }
        allow(validator_service).to receive(:call).with(params).and_return(true)

        eligibilizer = described_class.new(validator_params)
        result = eligibilizer.call(params)

        expect(result).to eq(false)
      end

      it 'returns false for income is 0, vehicle is nil and house is nil' do
        params = { income: 0, vehicle: nil, house: nil }
        allow(validator_service).to receive(:call).with(params).and_return(true)

        eligibilizer = described_class.new(validator_params)
        result = eligibilizer.call(params)

        expect(result).to eq(false)
      end
    end

    context 'when income, vehicle and house are valid types' do
      it 'returns true' do
        params = { income: 1, vehicle: { year: 2024 }, house: { ownership_status: 'owned' } }
        allow(validator_service).to receive(:call).with(params).and_return(true)

        eligibilizer = described_class.new(validator_params)
        result = eligibilizer.call(params)

        expect(result).to eq(true)
      end
    end
  end
end
