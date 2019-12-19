# frozen_string_literal: true

class ExpensePolicy
  attr_reader :user, :expense

  def initialize(user, expense)
    @user = user
    @expense = expense
  end

  def update?
    can_update_budget?
  end

  def destroy?
    can_update_budget?
  end

  private

  def can_update_budget?
    budget = expense.budget
    BudgetPolicy.new(user, budget).update?
  end
end
