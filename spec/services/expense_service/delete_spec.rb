# frozen_string_literal: true

require 'rails_helper'

describe ExpenseService::Delete, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(expense: expense).call }

    let!(:expense) { create(:expense) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'returns proper result' do
      expect(success).to eq(true)
    end

    it 'destroys given expense', :aggregate_failures do
      expect { service_call }.to change { Expense.count }.by(-1)
      expect(expense.persisted?).to eq(false)
    end

    context 'when expense cannot be destroyed' do
      before { allow(expense).to receive(:destroy).and_return(false) }

      it { is_expected.to be_failure }

      it 'returns proper error message' do
        expect(failure[:errors])
          .to include(I18n.t('services.expense_service.errors.cannot_delete'))
      end
    end
  end
end
