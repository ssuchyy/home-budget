# frozen_string_literal: true

module HomeBudget
  module V1
    class Base < Grape::API
      version 'v1', using: :path
      format :json

      resource :expenses do
        params do
          requires :motto, type: String
        end
        get do
          "Hello #{params['motto'] || 'motto!'}"
        end
      end
    end
  end
end
