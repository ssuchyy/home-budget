# frozen_string_literal: true

module V1
  module Users
    class ResetPassword < Grape::API
      resource :users do
        params do
          requires :reset_password_token, type: String
          requires :password, type: String
          requires :password_confirmation, type: String
        end

        patch :reset_password do
          user = User.reset_password_by_token(declared(params))

          if user.errors.present?
            error!(user.errors.full_messages, 400)
          else
            status(:no_content)
          end
        end
      end
    end
  end
end
