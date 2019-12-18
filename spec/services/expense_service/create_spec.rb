# frozen_string_literal: true

require 'rails_helper'

describe ExpenseService::Create, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(amount: amount, budget: budget).call
    end

    let(:amount) { 100 }
    let(:budget) { create(:budget) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'creates new expense' do
      expect { service_call }.to change { Expense.count }.by(1)
    end

    it 'returns newly created expense', :aggregate_failures do
      expect(success[:object]).to eq(Expense.last)
      expect(success[:object].amount).to eq(amount)
      expect(success[:object].budget).to eq(budget)
    end

    context 'when expense is invalid' do
      before do
        allow(Expense)
          .to receive(:new)
          .and_return(expense_double)
      end

      let(:expense_double) { instance_double(Expense, save: false, errors: errors_double) }

      let(:errors_double) do
        instance_double(ActiveModel::Errors, full_messages: stubbed_full_messages)
      end

      let(:stubbed_full_messages) { ['error1', 'error2'] }

      it { is_expected.to be_failure }

      it 'does not create any expense' do
        expect { service_call }.to_not change { Expense.count }
      end

      it 'returns validation errors full messages' do
        expect(failure[:errors]).to eq(stubbed_full_messages)
      end
    end
  end
end
