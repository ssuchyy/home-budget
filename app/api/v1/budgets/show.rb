# frozen_string_literal: true

module V1
  module Budgets
    class Show < Grape::API
      before do
        doorkeeper_authorize!
      end

      resource :budgets do
        route_param :budget_id do
          get do
            budget = Budget.find(params[:budget_id])

            authorize!(budget, :show?)

            Entities::V1::Budget.represent(budget)
          end
        end
      end
    end
  end
end
