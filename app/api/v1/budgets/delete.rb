# frozen_string_literal: true

module V1
  module Budgets
    class Delete < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :budgets do
        route_param :budget_id do
          delete do
            budget = Budget.find(params[:budget_id])

            authorize!(budget, :destroy?)

            result = BudgetService::Delete
                     .new(budget: budget)
                     .call

            handle_service_result(result)
          end
        end
      end
    end
  end
end
