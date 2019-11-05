# frozen_string_literal: true

module V1
  module Users
    class Base < Grape::API
      mount V1::Users::Register
    end
  end
end

