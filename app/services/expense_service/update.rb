# frozen_string_literal: true

module ExpenseService
  class Update < BaseService
    attribute :expense, Types::Instance(Expense)
    attribute :expense_params, Types::Strict::Hash

    def call
      update_expense
    end

    private

    def update_expense
      if expense.update(expense_params)
        Success(object: expense)
      else
        Failure(errors: expense.errors.full_messages)
      end
    end
  end
end
