# frozen_string_literal: true

module HouseholdAccountService
  class CreatePredefinedBudgets < BaseService
    attribute :household_account, Types::Instance(HouseholdAccount)

    def call
      create_predefined_budgets
    end

    private

    def create_predefined_budgets
      budgets_data = Budget::PREDEFINED_BUDGETS_NAMES.map { |name| { name: name } }

      household_account.budgets.create(budgets_data)

      Success(true)
    end
  end
end
