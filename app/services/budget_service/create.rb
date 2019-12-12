# frozen_string_literal: true

module BudgetService
  class Create < BaseService
    attribute :name, Types::Strict::String
    attribute :limit, Types::Coercible::Decimal
    attribute :household_account, Types::Instance(HouseholdAccount)

    def call
      create_budget
    end

    private

    def create_budget
      budget = Budget.new(name: name, limit: limit, household_account: household_account)

      if budget.save
        Success(object: budget)
      else
        Failure(errors: budget.errors.full_messages)
      end
    end
  end
end
