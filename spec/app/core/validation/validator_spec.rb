# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../app/core/validation/validator'

RSpec.describe Validator do # rubocop:disable Metrics/BlockLength
  let(:validations) do
    {
      name: %i[required type_string],
      age: [:type_integer, { min: 18 }],
      income: [{ max: 150_000 }]
    }
  end

  describe '#valid_rule?' do # rubocop:disable Metrics/BlockLength
    subject { described_class.new(validations) }

    context 'when the rule is a valid Symbol' do
      it 'returns true for valid symbol rules' do
        valid_symbols = Validator::RULES_MAPPING.keys

        valid_symbols.each do |symbol|
          expect(subject.send(:valid_rule?, symbol)).to be true
        end
      end
    end

    context 'when the rule is a valid Hash' do
      it 'returns true for valid hash rules' do
        valid_hashes = Validator::RULES_MAPPING.keys.map { |key| { key => nil } }

        valid_hashes.each do |hash|
          expect(subject.send(:valid_rule?, hash)).to be true
        end
      end
    end

    context 'when the rule is an invalid Symbol' do
      it 'returns false for invalid symbol rules' do
        invalid_symbols = %i[unknown_rule another_invalid_rule]

        invalid_symbols.each do |symbol|
          expect(subject.send(:valid_rule?, symbol)).to be false
        end
      end
    end

    context 'when the rule is an invalid Hash' do
      it 'returns false for invalid hash rules' do
        invalid_hashes = [{ unknown_rule: nil }, { another_invalid_rule: nil }]

        invalid_hashes.each do |hash|
          expect(subject.send(:valid_rule?, hash)).to be false
        end
      end
    end

    context 'when the rule is not a Symbol or Hash' do
      it 'returns false for invalid types' do
        invalid_types = [42, 'string', 3.14, [], Object.new]

        invalid_types.each do |invalid_type|
          expect(subject.send(:valid_rule?, invalid_type)).to be false
        end
      end
    end
  end
end
