# frozen_string_literal: true

module V1
  module Budgets
    class Base < Grape::API
      helpers ::Helpers::V1::Authorization

      mount V1::Budgets::Create
    end
  end
end
