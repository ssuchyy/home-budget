# frozen_string_literal: true

require 'rails_helper'

describe BudgetService::Create, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(name: name, limit: limit, household_account: household_account).call
    end

    let(:name) { FFaker::Product.brand }
    let(:limit) { 100 }
    let(:household_account) { create(:household_account) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'creates new budget' do
      expect { service_call }.to change { Budget.count }.by(1)
    end

    it 'returns newly created budget', :aggregate_failures do
      expect(success[:object]).to eq(Budget.last)
      expect(success[:object].name).to eq(name)
      expect(success[:object].limit).to eq(limit)
      expect(success[:object].household_account).to eq(household_account)
    end

    context 'when budget is invalid' do
      before do
        allow(Budget)
          .to receive(:new)
          .and_return(budget_double)
      end

      let(:budget_double) { instance_double(Budget, save: false, errors: errors_double) }

      let(:errors_double) do
        instance_double(ActiveModel::Errors, full_messages: stubbed_full_messages)
      end

      let(:stubbed_full_messages) { ['error1', 'error2'] }

      it { is_expected.to be_failure }

      it 'does not create any budget' do
        expect { service_call }.to_not change { Budget.count }
      end

      it 'returns validation errors full messages' do
        expect(failure[:errors]).to eq(stubbed_full_messages)
      end
    end
  end
end
