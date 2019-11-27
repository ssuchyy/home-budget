# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class Create < Grape::API
      helpers ::Helpers::V1::Authorization

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

          if result.success?
            Entities::V1::HouseholdAccount.represent(result.success[:household_account])
          else
            error!(result.failure[:errors], 400)
          end
        end
      end
    end
  end
end
