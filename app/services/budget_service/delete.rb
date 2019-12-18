# frozen_string_literal: true

module BudgetService
  class Delete < BaseService
    attribute :budget, Types::Instance(Budget)

    def call
      delete_budget
    end

    private

    def delete_budget
      if budget.destroy
        Success(true)
      else
        Failure(errors: [I18n.t('services.budget_service.errors.cannot_delete')])
      end
    end
  end
end
