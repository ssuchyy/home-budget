# frozen_string_literal: true

module V1
  module Budgets
    class Update < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :budgets do
        route_param :budget_id do
          params do
            optional :name, type: String
            optional :limit, type: Integer
            at_least_one_of :name, :limit
          end
          patch do
            budget = Budget.find(params[:budget_id])

            authorize!(budget, :update?)

            service_params = { budget: budget }.merge(budget_params: declared(params))

            result = BudgetService::Update
                     .new(service_params)
                     .call

            handle_service_result(result)
          end
        end
      end
    end
  end
end
