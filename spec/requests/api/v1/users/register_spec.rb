# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Users::Register, type: :request do
  describe 'api/v1/users/register' do
    subject(:make_request) { post '/api/v1/users/register', params: params }

    let(:params) { { email: email, password: password } }
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }

    it 'creates user' do
      expect { make_request }.to change { User.count }.by(1)
    end

    it 'returns newly created user', :aggregate_failures do
      make_request
      expect(response_body['id']).to eq(User.last.id)
      expect(response_body['email']).to eq(email)
    end

    context 'when something went wrong' do
      let(:register_service_double) do
        instance_double(UserService::Register,
                        call: register_service_result)
      end
      let(:register_service_result) { Dry::Monads::Result::Failure.new(errors: error_messages) }
      let(:error_messages) { ['first error', 'second error'] }

      before do
        allow(UserService::Register)
          .to receive(:new)
          .with(email: email, password: password)
          .and_return(register_service_double)
      end

      it_behaves_like 'returning error with proper error messages'
    end
  end
end
