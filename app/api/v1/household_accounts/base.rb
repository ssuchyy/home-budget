# frozen_string_literal: true

module V1
  module HouseholdAccounts
    class Base < Grape::API
      mount V1::HouseholdAccounts::Create
    end
  end
end
