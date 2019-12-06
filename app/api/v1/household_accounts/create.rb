# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class Create < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :household_accounts do
        params do
          requires :name, type: String
        end
        post do
          service_params = declared(params)
                           .merge(user: current_user)
                           .symbolize_keys

          result = HouseholdAccountService::Create
                   .new(service_params)
                   .call

          handle_service_result(result)
        end
      end
    end
  end
end
