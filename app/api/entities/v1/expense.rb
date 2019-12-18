# frozen_string_literal: true

module Entities
  module V1
    class Expense < Grape::Entity
      expose :id
      expose :amount
      expose :budget_id
    end
  end
end
