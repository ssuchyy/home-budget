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

          if result.success?
            Entities::V1::User.represent(result.success[:user])
          else
            error!(result.failure[:errors], 400)
          end
        end
      end
    end
  end
end
