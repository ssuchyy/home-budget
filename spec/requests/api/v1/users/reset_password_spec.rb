# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Users::ResetPassword, type: :request do
  describe 'api/v1/users/reset_password' do
    subject(:make_request) { patch '/api/v1/users/reset_password', params: params }

    let(:params) do
      {
        reset_password_token: reset_password_token,
        password: password,
        password_confirmation: password_confirmation
      }
    end

    let(:password) { FFaker::Internet.unique.password }
    let(:password_confirmation) { password }

    let(:user) { create(:user) }
    let(:user_reset_password_token) { user.send_reset_password_instructions }

    context 'when reset password token is valid' do
      let(:reset_password_token) { user_reset_password_token }

      it_behaves_like 'returning status code', 204

      it 'resets user password' do
        make_request
        expect(user.reload.valid_password?(password)).to be true
      end
    end

    context 'when reset password token is invalid' do
      let(:reset_password_token) { 'invalid_token' }
      let(:error_messages) { ['Reset password token is invalid'] }

      it_behaves_like 'returning error with proper error messages'
    end
  end
end
