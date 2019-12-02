# frozen_string_literal: true

module HouseholdAccountService
  class InviteUsers < BaseService
    attribute :household_account, Types::Instance(HouseholdAccount)
    attribute :users_emails, Types::Strict::Array.of(Types::String)

    def call
      filter_users_with_household_accounts
        .bind { invite_users }
    end

    private

    def filter_users_with_household_accounts
      users_emails.reject! do |email|
        User
          .where(email: email)
          .where.not(household_account: nil).exists?
      end

      Success(true)
    end

    def invite_users
      users_emails.each do |email|
        User.invite!(email: email, household_account: household_account)
      end

      Success(true)
    end
  end
end
