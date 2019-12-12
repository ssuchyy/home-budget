# frozen_string_literal: true

module V1
  module Users
    class Register < Grape::API
      resource :users do
        params do
          requires :email, type: String
          requires :password, type: String
        end

        post :register do
          result = UserService::Register
                   .new(email: params[:email],
                        password: params[:password])
                   .call

          handle_service_result(result)
        end
      end
    end
  end
end
