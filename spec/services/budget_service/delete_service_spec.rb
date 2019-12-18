# frozen_string_literal: true

require 'rails_helper'

describe BudgetService::Delete, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(budget: budget).call }

    let!(:budget) { create(:budget) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'returns proper result' do
      expect(success).to eq(true)
    end

    it 'destroys given budget', :aggregate_failures do
      expect { service_call }.to change { Budget.count }.by(-1)
      expect(budget.persisted?).to eq(false)
    end

    context 'when budget cannot be destroyed' do
      before { allow(budget).to receive(:destroy).and_return(false) }

      it { is_expected.to be_failure }

      it 'returns proper error message' do
        expect(failure[:errors])
          .to include(I18n.t('services.budget_service.errors.cannot_delete'))
      end
    end
  end
end
