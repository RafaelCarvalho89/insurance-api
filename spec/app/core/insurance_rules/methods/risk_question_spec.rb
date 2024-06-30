# frozen_string_literal: true

require 'spec_helper'

require_relative '../../../../../app/core/insurance_rules/methods/risk_question'

module InsuranceRules
  RSpec.describe RiskQuestionMethods do # rubocop:disable Metrics/BlockLength
    include RiskQuestionMethods

    describe '# validate_risk_questions_input' do
      it 'raises an ArgumentError when the risk_questions is not an array' do
        expect { validate_risk_questions_input('25') }.to raise_error(ArgumentError)
        expect { validate_risk_questions_input(-1) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when the risk_questions is not an array with size of 3' do
        expect { validate_risk_questions_input([1, 1]) }.to raise_error(ArgumentError)
        expect { validate_risk_questions_input([1, 1, 1, 1]) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when the risk_questions is not an array with 0 or 1' do
        expect { validate_risk_questions_input([1, 1, 2]) }.to raise_error(ArgumentError)
      end
    end

    describe '# sum_risk_questions' do
      it 'raises an ArgumentError when the risk_questions is not an array' do
        expect { sum_risk_questions('25') }.to raise_error(ArgumentError)
        expect { sum_risk_questions(-1) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when the risk_questions is not an array with size of 3' do
        expect { sum_risk_questions([1, 1]) }.to raise_error(ArgumentError)
        expect { sum_risk_questions([1, 1, 1, 1]) }.to raise_error(ArgumentError)
      end

      it 'raises an ArgumentError when the risk_questions is not an array with 0 or 1' do
        expect { sum_risk_questions([1, 1, 2]) }.to raise_error(ArgumentError)
      end

      it 'returns the sum of the risk_questions' do
        expect(sum_risk_questions([0, 1, 1])).to eq(2)
      end
    end
  end
end
