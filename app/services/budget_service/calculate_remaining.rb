# frozen_string_literal: true

module BudgetService
  class CalculateRemaining < BaseService
    attribute :budget, Types::Instance(Budget)

    def call
      sum_expenses
        .bind { calculate_remaining }
    end

    private

    attr_reader :expenses_sum

    def sum_expenses
      @expenses_sum = budget.expenses.map(&:amount).reduce(:+) || 0.to_d
      Success(true)
    end

    def calculate_remaining
      remaining = budget.limit - expenses_sum
      Success(remaining: remaining)
    end
  end
end
