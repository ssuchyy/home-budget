# frozen_string_literal: true

module Entities
  module V1
    class HouseholdAccount < Grape::Entity
      expose :id
      expose :name
      expose :active_users, using: Entities::V1::User, as: :users
    end
  end
end
