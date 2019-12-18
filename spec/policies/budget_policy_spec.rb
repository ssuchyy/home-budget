# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BudgetPolicy, type: :policy do
  let(:policy) { described_class.new(user, budget) }
  let(:user) { build_stubbed(:user) }
  let(:budget) { build_stubbed(:budget, household_account: household_account) }
  let(:household_account) { build_stubbed(:household_account) }

  describe 'update?' do
    subject { policy.update? }

    before do
      allow(HouseholdAccountPolicy)
        .to receive(:new)
        .with(user, household_account)
        .and_return(household_account_policy_double)
    end

    let(:household_account_policy_double) do
      instance_double(HouseholdAccountPolicy, manage?: can_manage_household_account)
    end

    context 'when user is able to manage household account to which budget belongs' do
      let(:can_manage_household_account) { true }

      it { is_expected.to be true }
    end

    context 'when user cannot manage household account to which budget belongs' do
      let(:can_manage_household_account) { false }

      it { is_expected.to be false }
    end
  end
end
