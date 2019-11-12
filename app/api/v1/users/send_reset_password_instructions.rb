# frozen_string_literal: true

module V1
  module Users
    class SendResetPasswordInstructions < Grape::API
      resource :users do
        params do
          requires :email, type: String
        end

        patch :send_reset_password_instructions do
          user = User.find_by(email: params[:email])
          user.send_reset_password_instructions if user.present?

          status(:no_content)
        end
      end
    end
  end
end
