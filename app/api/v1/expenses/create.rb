# frozen_string_literal: true

module V1
  module Expenses
    class Create < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :budgets do
        route_param :budget_id do
          resource :expenses do
            params do
              requires :amount, type: Integer
            end
            post do
              budget = Budget.find(params[:budget_id])

              authorize!(budget, :update?)

              service_params = declared(params)
                               .merge(budget: budget)
                               .symbolize_keys

              result = ExpenseService::Create
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
