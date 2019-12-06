# frozen_string_literal: true

require 'rails_helper'

describe HouseholdAccountService::Delete, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new(household_account: household_account).call }

    let!(:household_account) { create(:household_account) }

    let(:success) { subject.success }
    let(:failure) { subject.failure }

    it { is_expected.to be_success }

    it 'returns proper result' do
      expect(success).to eq(true)
    end

    it 'destroys given household account', :aggregate_failures do
      expect { service_call }.to change { HouseholdAccount.count }.by(-1)
      expect(household_account.persisted?).to eq(false)
    end

    context 'when household account has a user' do
      let!(:household_account) { create(:household_account, :with_user) }
      let(:user) { household_account.users.first }

      it 'clears household account id for user' do
        expect { service_call }.to change { user.reload.household_account_id }.to(nil)
      end
    end

    context 'when household account cannot be destroyed' do
      before { allow(household_account).to receive(:destroy).and_return(false) }

      it { is_expected.to be_failure }

      it 'returns proper error message' do
        expect(failure[:errors])
          .to include(I18n.t('services.household_account_service.errors.cannot_delete'))
      end
    end
  end
end
