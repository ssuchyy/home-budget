# frozen_string_literal: true

module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    rescue_from ActiveRecord::RecordNotFound do
      error!(I18n.t('api.errors.not_found'), 404)
    end

    rescue_from Pundit::NotAuthorizedError do
      error!(I18n.t('api.errors.unauthorized'), 401)
    end

    helpers ::Helpers::V1::Services

    mount V1::Users::Base
    mount V1::HouseholdAccounts::Base
    mount V1::Budgets::Base
    mount V1::Expenses::Base
  end
end
