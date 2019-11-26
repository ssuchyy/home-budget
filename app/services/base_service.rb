# frozen_string_literal: true

class BaseService < Dry::Struct
  include Dry::Monads[:result]

  module Types
    include Dry.Types()
  end
end
