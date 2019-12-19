# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpensePolicy, type: :policy do
  let(:policy) { described_class.new(user, expense) }
  let(:user) { build_stubbed(:user) }
  let(:expense) { build_stubbed(:expense, budget: budget) }
  let(:budget) { build_stubbed(:budget) }

  before do
    allow(BudgetPolicy)
      .to receive(:new)
      .with(user, budget)
      .and_return(budget_policy_double)
  end

  let(:budget_policy_double) do
    instance_double(BudgetPolicy, update?: can_update_budget)
  end

  shared_examples 'corresponding to user ability to update budget' do
    context 'when user is able to update budget' do
      let(:can_update_budget) { true }

      it { is_expected.to be true }
    end

    context 'when user cannot update budget' do
      let(:can_update_budget) { false }

      it { is_expected.to be false }
    end
  end

  describe 'update?' do
    subject { policy.update? }

    it_behaves_like 'corresponding to user ability to update budget'
  end

  describe 'update?' do
    subject { policy.destroy? }

    it_behaves_like 'corresponding to user ability to update budget'
  end
end
