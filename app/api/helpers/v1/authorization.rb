# frozen_string_literal: true

require 'doorkeeper/grape/helpers'

module Helpers
  module V1
    module Authorization
      extend ::Grape::API::Helpers
      include Doorkeeper::Grape::Helpers

      def current_user
        @current_user = User.find(doorkeeper_token.resource_owner_id)
      end

      def authorize!(resource, action)
        Pundit.authorize(current_user, resource, action)
      end
    end
  end
end
