# frozen_string_literal: true

module Entities
  module V1
    class Budget < Grape::Entity
      expose :id
      expose :name
      expose :limit
      expose :household_account_id
    end
  end
end
