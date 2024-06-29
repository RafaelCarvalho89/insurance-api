# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/house'

module InsuranceRules
  RSpec.describe 'House Methods house?' do # rubocop:disable Metrics/BlockLength
    include HouseMethods

    let(:invalid_ownership_status_list) { [{}, [], 1, 'invalid_status', true, false, nil] }

    describe '# ownership_status?' do
      it 'returns true when is valid status' do
        expect(ownership_status?('owned')).to be true
        expect(ownership_status?('rented')).to be true
      end

      it 'returns false when is invalid status' do
        invalid_ownership_status_list.each do |value|
          expect(ownership_status?(value)).to be false
        end
      end
    end

    describe '# house?' do
      it 'raises an error when is invalid format' do
        [{}, [], 1, 'any_string', true, false].each do |value|
          expect { house?(value) }.to raise_error(ArgumentError)
        end

        invalid_ownership_status_list.each do |invalid_status|
          expect { house?(house: { ownership_status: invalid_status }) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when is valid format' do
        expect(house?({ ownership_status: 'owned' })).to be true
        expect(house?({ ownership_status: 'rented' })).to be true
      end

      it 'returns false when is house is nil' do
        expect(house?(nil)).to be false
      end
    end

    describe '# rented?' do
      it 'raises an error when is invalid format' do
        invalid_ownership_status_list.each do |value|
          expect { rented?(value) }.to raise_error(ArgumentError)
        end
      end

      it 'returns true when is ownership_status is rented' do
        expect(rented?('rented')).to be true
      end

      it 'returns false when is ownership_status is owned' do
        expect(rented?('owned')).to be false
      end
    end
  end
end
