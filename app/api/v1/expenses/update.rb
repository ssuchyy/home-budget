# frozen_string_literal: true

module V1
  module Expenses
    class Update < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :expenses do
        route_param :expense_id do
          params do
            requires :amount, type: Integer
          end
          patch do
            expense = Expense.find(params[:expense_id])

            authorize!(expense, :update?)

            service_params = { expense: expense }.merge(expense_params: declared(params))

            result = ExpenseService::Update
                     .new(service_params)
                     .call

            handle_service_result(result)
          end
        end
      end
    end
  end
end
