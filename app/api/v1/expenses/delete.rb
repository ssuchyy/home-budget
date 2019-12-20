# frozen_string_literal: true

module V1
  module Expenses
    class Delete < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :expenses do
        route_param :expense_id do
          delete do
            expense = Expense.find(params[:expense_id])

            authorize!(expense, :destroy?)

            result = ExpenseService::Delete
                     .new(expense: expense)
                     .call

            handle_service_result(result)
          end
        end
      end
    end
  end
end
