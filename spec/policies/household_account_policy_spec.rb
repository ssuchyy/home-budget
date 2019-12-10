# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HouseholdAccountPolicy, type: :policy do
  let(:policy) { described_class.new(user, household_account) }
  let(:user) { create(:user) }
  let(:household_account) { create(:household_account) }

  describe 'manage?' do
    subject { policy.manage? }

    context 'when user does not belong to given household account' do
      it { is_expected.to be false }
    end

    context 'when user belongs to given household account' do
      let(:user) { create(:user, household_account: household_account) }

      it { is_expected.to be true }
    end
  end

  describe 'destroy?' do
    subject { policy.destroy? }

    context 'when user can manage given household account' do
      before do
        allow(policy).to receive(:manage?).and_return(true)
        allow(policy).to receive(:destroy?).and_call_original
      end

      it { is_expected.to be true }
    end

    context 'when user cannot manage given household account' do
      before do
        allow(policy).to receive(:manage?).and_return(false)
        allow(policy).to receive(:destroy?).and_call_original
      end

      it { is_expected.to be false }
    end
  end
end
