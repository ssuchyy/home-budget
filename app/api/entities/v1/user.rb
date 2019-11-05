# frozen_string_literal: true

module Entities
  module V1
    class User < Grape::Entity
      expose :id
      expose :email
    end
  end
end
