# frozen_string_literal: true

module HouseholdAccountService
  class Delete < BaseService
    attribute :household_account, Types::Instance(HouseholdAccount)

    def call
      delete_account
    end

    private

    def delete_account
      if household_account.destroy
        Success(true)
      else
        Failure(errors: [I18n.t('services.household_account_service.errors.cannot_delete')])
      end
    end
  end
end
