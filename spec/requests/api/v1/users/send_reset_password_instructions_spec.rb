# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Users::Register, type: :request do
  describe 'api/v1/users/registration' do
    subject { patch '/api/v1/users/send_reset_password_instructions', params: params }

    let(:params) { { email: email } }

    context 'when user does not exist' do
      let(:email) { FFaker::Internet.email }

      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(204)
      end
    end

    context 'when user exists' do
      let(:user) { create(:user) }
      let(:email) { user.email }

      before { allow(User).to receive(:find_by).with(email: user.email).and_return(user) }

      it 'returns 200 status code' do
        subject
        expect(response).to have_http_status(204)
      end

      it 'sends reset password instructions for that user' do
        expect(user).to receive(:send_reset_password_instructions)
        subject
      end
    end
  end
end
