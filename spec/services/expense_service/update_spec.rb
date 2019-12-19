# frozen_string_literal: true

require 'rails_helper'

describe ExpenseService::Update, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(expense: expense, expense_params: expense_params).call
    end

    let(:expense) { create(:expense) }
    let(:expense_params) do
      {
        amount: amount
      }
    end

    let(:amount) { 250 }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'updates existing expense' do
      expect { service_call }
        .to change { expense.amount }.to(amount)
    end

    it 'returns updated expense' do
      expect(success[:object]).to eq(expense)
    end

    context 'when expense cannot be updated' do
      before do
        allow(expense)
          .to receive(:update)
          .and_return(false)
        allow(expense)
          .to receive(:errors)
          .and_return(errors_double)
      end

      let(:errors_double) do
        instance_double(ActiveModel::Errors, full_messages: stubbed_full_messages)
      end

      let(:stubbed_full_messages) { ['error1', 'error2'] }

      it { is_expected.to be_failure }

      it 'does not update expense' do
        expect { service_call }.to_not change { expense }
      end

      it 'returns validation errors full messages' do
        expect(failure[:errors]).to eq(stubbed_full_messages)
      end
    end
  end
end
