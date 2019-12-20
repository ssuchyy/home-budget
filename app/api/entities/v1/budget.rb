# frozen_string_literal: true

module Entities
  module V1
    class Budget < Grape::Entity
      expose :id
      expose :name
      expose :limit
      expose :remaining
      expose :household_account_id

      private

      def remaining
        BudgetService::CalculateRemaining
          .new(budget: object)
          .call
          .value![:remaining]
      end
    end
  end
end
