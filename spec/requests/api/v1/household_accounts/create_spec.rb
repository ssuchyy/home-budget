# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::HouseholdAccounts::Create, type: :request do
  describe 'api/v1/household_accounts' do
    subject(:make_request) { post '/api/v1/household_accounts', params: params, headers: headers }

    let(:params) { { name: name } }
    let(:headers) { nil }

    let(:name) { FFaker::Company.name }
    let(:user) { create(:user) }

    it_behaves_like 'authenticating user'

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:authenticated_user) { user }
      let(:headers) { authentication_headers }

      let(:create_service_double) do
        instance_double(HouseholdAccountService::Create,
                        call: create_service_result)
      end

      before do
        allow(HouseholdAccountService::Create)
          .to receive(:new)
          .with(user: user, name: name)
          .and_return(create_service_double)
      end

      context 'when create service ends with success' do
        let(:create_service_result) do
          Dry::Monads::Result::Success.new(household_account: household_account)
        end
        let(:household_account) { create(:household_account, name: name, users: [user]) }

        it_behaves_like 'returning status code', :created

        it 'returns newly created household account', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(HouseholdAccount.last.id)
          expect(response_body['name']).to eq(name)
          expect(response_body['users'][0]['email']).to eq(user.email)
        end
      end

      context 'when create service ends with failure' do
        let(:create_service_result) do
          Dry::Monads::Result::Failure.new(errors: error_messages)
        end
        let(:error_messages) { ['error'] }

        it_behaves_like 'returning error with proper error messages'
      end
    end
  end
end
