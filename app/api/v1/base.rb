# frozen_string_literal: true

module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    mount V1::Users::Base
    mount V1::HouseholdAccounts::Base
  end
end
