# frozen_string_literal: true

module HouseholdAccountService
  class Create < BaseService
    attribute :user, Types::Instance(User)
    attribute :name, Types::String

    def call
      check_if_user_already_has_household_account
        .bind(method(:create_household_account))
        .bind(method(:create_predefined_budgets))
    end

    private

    def check_if_user_already_has_household_account
      if user.household_account.present?
        Failure(errors: [I18n.t('services.household_account_service.errors.already_has_account')])
      else
        Success(true)
      end
    end

    def create_household_account(_)
      household_account = HouseholdAccount.new(name: name, users: [user])

      if household_account.save
        Success(household_account: household_account)
      else
        Failure(errors: household_account.errors.full_messages)
      end
    end

    def create_predefined_budgets(household_account:)
      HouseholdAccountService::CreatePredefinedBudgets
        .new(household_account: household_account)
        .call

      Success(object: household_account)
    end
  end
end
