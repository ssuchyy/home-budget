# frozen_string_literal: true

module Entities
  module V1
    class HouseholdAccount < Grape::Entity
      expose :id
      expose :name
      expose :users, using: Entities::V1::User
    end
  end
end
