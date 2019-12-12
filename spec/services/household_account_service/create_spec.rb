# frozen_string_literal: true

require 'rails_helper'

describe HouseholdAccountService::Create, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(user: user, name: name).call }

    let(:name) { FFaker::Company.name }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    context 'when user does not have a household account yet' do
      let(:user) { create(:user) }
      let(:create_predefined_budgets_service_double) do
        instance_double(HouseholdAccountService::CreatePredefinedBudgets)
      end

      it { is_expected.to be_success }

      it 'creates new household account associated with given user', :aggregate_failures do
        expect { service_call }.to change { HouseholdAccount.count }.by(1)
        expect(user.reload.household_account).to eq(HouseholdAccount.last)
      end

      it 'calls service that creates predefined budgets', :aggregate_failures do
        expect(HouseholdAccountService::CreatePredefinedBudgets)
          .to receive(:new)
          .and_return(create_predefined_budgets_service_double)
        expect(create_predefined_budgets_service_double)
          .to receive(:call)
        service_call
      end

      context 'when household account cannot be saved' do
        before do
          allow(HouseholdAccount)
            .to receive(:new)
            .and_return(household_account_double)
        end

        let(:household_account_double) do
          instance_double(HouseholdAccount, save: false, errors: errors_double)
        end

        let(:errors_double) do
          instance_double(ActiveModel::Errors, full_messages: stubbed_full_messages)
        end

        let(:stubbed_full_messages) { ['error1', 'error2'] }

        it { is_expected.to be_failure }

        it 'does not create any household accounts' do
          expect { service_call }.to_not change { HouseholdAccount.count }
        end

        it 'returns validation errors full messages' do
          expect(failure[:errors]).to eq(stubbed_full_messages)
        end
      end
    end

    context 'when user already has a household account' do
      let(:user) { create(:user, :with_household_account) }

      it { is_expected.to be_failure }

      it 'returns proper error message' do
        expect(failure[:errors])
          .to include(I18n.t('services.household_account_service.errors.already_has_account'))
      end
    end
  end
end
