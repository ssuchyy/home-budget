# frozen_string_literal: true

class API < Grape::API
  prefix 'api'

  mount V1::Base

  add_swagger_documentation(mount_path: '/docs')
end
