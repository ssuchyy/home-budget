# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OAuth', type: :request do
  describe '/oauth/token' do
    subject { post '/oauth/token', params: params }

    let(:user) { create(:user, password: 'password') }

    shared_examples 'returning invalid grant error' do
      it 'returns invalid grant error', :aggregate_failures do
        subject
        expect(response).to have_http_status(400)
        expect(response_body['error']).to eq('invalid_grant')
      end
    end

    context 'when user does not exist' do
      let(:params) do
        {
          grant_type: 'password',
          email: 'idonotexist@example.com',
          password: 'password'
        }
      end

      it_behaves_like 'returning invalid grant error'
    end

    context 'when user exists' do
      let(:user) { create(:user, password: 'password') }

      let(:params) do
        {
          grant_type: 'password',
          email: email,
          password: password
        }
      end

      let(:email) { user.email }

      context 'when valid password is provided' do
        let(:password) { 'password' }

        it 'returns expirable auth token', :aggregate_failures do
          subject
          expect(response_body).to have_key('access_token')
          expect(response_body).to have_key('created_at')
          expect(response_body['token_type']).to eq('Bearer')
          expect(response_body['expires_in']).to eq(7200)
        end
      end

      context 'when invalid password is provided' do
        let(:password) { 'invalid_password' }

        it_behaves_like 'returning invalid grant error'
      end
    end
  end
end
