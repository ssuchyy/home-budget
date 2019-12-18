# frozen_string_literal: true

module ExpenseService
  class Create < BaseService
    attribute :budget, Types::Instance(Budget)
    attribute :amount, Types::Coercible::Decimal

    def call
      create_expense
    end

    private

    def create_expense
      expense = Expense.new(amount: amount, budget: budget)

      if expense.save
        Success(object: expense)
      else
        Failure(errors: expense.errors.full_messages)
      end
    end
  end
end
