# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class InviteUsers < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :household_accounts do
        route_param :id do
          params do
            requires :emails, type: Array[String]
          end
          post :invite_users do
            household_account = HouseholdAccount.find(params[:id])

            authorize!(household_account, :manage?)

            HouseholdAccountService::InviteUsers
              .new(household_account: household_account, users_emails: params[:emails])
              .call

            status :no_content
          end
        end
      end
    end
  end
end
