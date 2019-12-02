# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class Base < Grape::API
      helpers ::Helpers::V1::Authorization

      mount V1::HouseholdAccounts::Create
      mount V1::HouseholdAccounts::InviteUsers
    end
  end
end
