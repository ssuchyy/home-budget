# frozen_string_literal: true

module HouseholdAccountService
  class Create < BaseService
    attribute :user, Types::Instance(User)
    attribute :name, Types::String

    def call
      check_if_user_already_has_household_account
        .bind { create_household_account }
    end

    private

    def check_if_user_already_has_household_account
      if user.household_account.present?
        Failure(errors: [I18n.t('services.household_account_service.errors.already_has_account')])
      else
        Success(true)
      end
    end

    def create_household_account
      account = HouseholdAccount.new(name: name, users: [user])

      if account.save
        Success(household_account: account)
      else
        Failure(errors: account.errors.full_messages)
      end
    end
  end
end
