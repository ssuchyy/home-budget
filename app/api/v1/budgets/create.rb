# frozen_string_literal: true

module V1
  module Budgets
    class Create < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :household_accounts do
        route_param :household_account_id do
          resource :budgets do
            params do
              requires :name, type: String
              requires :limit, type: Integer
            end
            post do
              household_account = HouseholdAccount.find(params[:household_account_id])

              authorize!(household_account, :manage?)

              service_params = declared(params)
                               .merge(household_account: household_account)
                               .symbolize_keys

              result = BudgetService::Create
                       .new(service_params)
                       .call

              handle_service_result(result)
            end
          end
        end
      end
    end
  end
end
