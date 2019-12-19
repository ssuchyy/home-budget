# frozen_string_literal: true

module ExpenseService
  class Delete < BaseService
    attribute :expense, Types::Instance(Expense)

    def call
      delete_expense
    end

    private

    def delete_expense
      if expense.destroy
        Success(true)
      else
        Failure(errors: [I18n.t('services.expense_service.errors.cannot_delete')])
      end
    end
  end
end
