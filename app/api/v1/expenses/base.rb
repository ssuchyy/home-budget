# frozen_string_literal: true

module V1
  module Expenses
    class Base < Grape::API
      helpers ::Helpers::V1::Authorization

      mount V1::Expenses::Create
      mount V1::Expenses::Update
      mount V1::Expenses::Delete
    end
  end
end
