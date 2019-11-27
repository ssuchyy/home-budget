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

      it { is_expected.to be_success }

      it 'creates new household account associated with given user', :aggregate_failures do
        expect { service_call }.to change { HouseholdAccount.count }.by(1)
        expect(user.reload.household_account).to eq(HouseholdAccount.last)
      end

      context 'when household account cannot be saved' do
        before do
          allow_any_instance_of(HouseholdAccount)
            .to receive(:save)
            .and_return(false)
          allow_any_instance_of(HouseholdAccount)
            .to receive(:errors)
            .and_return(errors_double)
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
