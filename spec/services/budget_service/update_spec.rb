# frozen_string_literal: true

require 'rails_helper'

describe BudgetService::Update, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(budget: budget, budget_params: budget_params).call
    end

    let(:budget) { create(:budget) }
    let(:budget_params) do
      {
        name: name,
        limit: limit
      }
    end

    let(:name) { 'completely_new_budget_name' }
    let(:limit) { 250 }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'updates existing budget' do
      expect { service_call }
        .to change { budget.name }.to(name)
        .and change { budget.limit }.to(limit)
    end

    it 'returns updated budget', :aggregate_failures do
      expect(success[:object]).to eq(budget)
    end

    context 'when budget cannot be updated' do
      before do
        allow(budget)
          .to receive(:update)
          .and_return(false)
        allow(budget)
          .to receive(:errors)
          .and_return(errors_double)
      end

      let(:errors_double) do
        instance_double(ActiveModel::Errors, full_messages: stubbed_full_messages)
      end

      let(:stubbed_full_messages) { ['error1', 'error2'] }

      it { is_expected.to be_failure }

      it 'does not update budget' do
        expect { service_call }.to_not change { budget }
      end

      it 'returns validation errors full messages' do
        expect(failure[:errors]).to eq(stubbed_full_messages)
      end
    end
  end
end
