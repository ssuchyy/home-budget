# frozen_string_literal: true

class BudgetPolicy
  attr_reader :user, :budget

  def initialize(user, budget)
    @user = user
    @budget = budget
  end

  def update?
    household_account = budget.household_account
    HouseholdAccountPolicy.new(user, household_account).manage?
  end
end
