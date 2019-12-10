# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class Delete < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :household_accounts do
        route_param :id do
          delete do
            household_account = HouseholdAccount.find(params[:id])

            authorize!(household_account, :destroy?)

            result = HouseholdAccountService::Delete
                     .new(household_account: household_account)
                     .call

            handle_service_result(result)
          end
        end
      end
    end
  end
end
