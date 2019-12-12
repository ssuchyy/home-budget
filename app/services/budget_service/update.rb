# frozen_string_literal: true

module BudgetService
  class Update < BaseService
    attribute :budget, Types::Instance(Budget)
    attribute :budget_params, Types::Strict::Hash

    def call
      update_budget
    end

    private

    def update_budget
      if budget.update(budget_params)
        Success(object: budget)
      else
        Failure(errors: budget.errors.full_messages)
      end
    end
  end
end
