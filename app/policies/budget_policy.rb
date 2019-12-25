# frozen_string_literal: true

class BudgetPolicy
  attr_reader :user, :budget

  def initialize(user, budget)
    @user = user
    @budget = budget
  end

  def show?
    can_manage_household_account?
  end

  def update?
    can_manage_household_account?
  end

  def destroy?
    can_manage_household_account?
  end

  private

  def can_manage_household_account?
    household_account = budget.household_account
    HouseholdAccountPolicy.new(user, household_account).manage?
  end
end
