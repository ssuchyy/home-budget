# frozen_string_literal: true

require 'rails_helper'

describe HouseholdAccountService::CreatePredefinedBudgets, type: :service do
  describe '#call' do
    subject(:service_call) do
      described_class.new(household_account: household_account).call
    end

    let(:household_account) { create(:household_account) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    let(:created_budgets_names) { household_account.reload.budgets.map(&:name) }

    it { is_expected.to be_success }

    context 'when household account does not have any budgets yet' do
      it 'creates all predefined budgets', :aggregate_failures do
        expect { service_call }
          .to change { Budget.count }
          .by(Budget::PREDEFINED_BUDGETS_NAMES.size)
        expect(created_budgets_names).to include(*Budget::PREDEFINED_BUDGETS_NAMES)
      end
    end

    context 'when household account already has one budget with predefined name' do
      let!(:existing_budget) do
        create(:budget,
               name: Budget::PREDEFINED_BUDGETS_NAMES.first,
               limit: 250,
               household_account: household_account)
      end

      it 'creates remaining predefined budgets', :aggregate_failures do
        expect { service_call }
          .to change { Budget.count }
          .by(Budget::PREDEFINED_BUDGETS_NAMES.size - 1)
        expect(created_budgets_names).to include(*Budget::PREDEFINED_BUDGETS_NAMES)
      end

      it 'does not change existing budget' do
        expect { service_call }.to_not change { existing_budget }
      end
    end
  end
end
