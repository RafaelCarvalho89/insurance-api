# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/vehicle'

module InsuranceRules
  RSpec.describe VehicleMethods do # rubocop:disable Metrics/BlockLength
    include VehicleMethods

    let(:next_year) { Time.now.year + 1 }
    let(:invalid_vehicle_year_list) { [-1, 0, 1885, next_year, {}, [], 'any_string', true, false, nil] }
    let(:invalid_vehicle_list) { [{}, [], 1, 'any_string', true, false] }

    describe '#validate_vehicle_year_input' do
      it 'raises an error when is invalid format' do
        invalid_vehicle_year_list.each do |value|
          expect { validate_vehicle_year_input(value) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#vehicle_year?' do
      it 'raises an error when is invalid format' do
        invalid_vehicle_year_list.each do |value|
          expect { vehicle_year?(value) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '#validate_vehicle_input' do
      it 'raises an error when is invalid format' do
        invalid_vehicle_year_list.each do |value|
          expect { validate_vehicle_input(vehicle: { year: value }) }.to raise_error(ArgumentError)
        end

        invalid_vehicle_list.each do |value|
          expect { validate_vehicle_input(value) }.to raise_error(ArgumentError)
        end
      end
    end

    describe '# vehicle?' do
      it 'raises an error when is invalid format' do
        invalid_vehicle_list.each do |value|
          expect { vehicle?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when is valid format' do
        expect(vehicle?({ year: 1886 })).to be true
        expect(vehicle?({ year: Time.now.year })).to be true
      end

      it 'returns false when is vehicle year is nil' do
        expect(vehicle?(nil)).to be false
      end
    end

    describe '#vehicle_more_than_5_years?' do
      it 'raises an error when is invalid format' do
        invalid_vehicle_year_list.each do |value|
          expect { vehicle_more_than_5_years?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when is vehicle year is more than 5 years' do
        six_years_ago = Time.now.year - 6
        expect(vehicle_more_than_5_years?(1886)).to be true
        expect(vehicle_more_than_5_years?(six_years_ago)).to be true
      end

      it 'returns false when is vehicle year is less than 5 years' do
        this_year = Time.now.year
        five_years_ago = this_year - 5
        expect(vehicle_more_than_5_years?(five_years_ago)).to be false
        expect(vehicle_more_than_5_years?(this_year)).to be false
      end
    end
  end
end
