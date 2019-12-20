# frozen_string_literal: true

require 'rails_helper'

describe BudgetService::CalculateRemaining, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(budget: budget).call
    end

    let(:budget) { create(:budget, limit: limit) }
    let(:limit) { 100 }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    context 'when budget does not have any expenses' do
      it { is_expected.to be_success }

      it 'returns budget limit' do
        expect(success[:remaining]).to eq(limit)
      end
    end

    context 'when budget have some expenses' do
      let(:expense_amount1) { 15.65.to_d }
      let(:expense_amount2) { 30.24.to_d }
      let(:expenses_sum) { expense_amount1 + expense_amount2 }

      before do
        create(:expense, amount: expense_amount1, budget: budget)
        create(:expense, amount: expense_amount2, budget: budget)
      end

      shared_examples 'returning diff between budget limit and expeses sum' do
        it 'returns difference between budget limit and sum of the expeses' do
          expect(success[:remaining]).to eq(budget.limit - expenses_sum)
        end
      end

      it { is_expected.to be_success }

      it_behaves_like 'returning diff between budget limit and expeses sum'

      context 'when expenses sum exceeds budget limit' do
        let(:expense_amount1) { 75.to_d }
        let(:expense_amount2) { 40.to_d }

        it { is_expected.to be_success }

        it_behaves_like 'returning diff between budget limit and expeses sum'
      end
    end
  end
end
