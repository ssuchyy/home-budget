# frozen_string_literal: true

require 'doorkeeper/grape/helpers'

module Helpers
  module V1
    module Services
      extend ::Grape::API::Helpers

      def handle_service_result(result)
        return error!(result.failure[:errors], 400) unless result.success?

        if result.success == true
          status :no_content
        else
          object = result.success[:object]
          klass = object.class
          entity_klass = "Entities::V1::#{klass}".constantize
          entity_klass.represent(object)
        end
      end
    end
  end
end
