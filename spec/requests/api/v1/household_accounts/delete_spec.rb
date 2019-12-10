# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::HouseholdAccounts::Delete, type: :request do
  describe 'api/v1/household_accounts/:id/delete' do
    subject(:make_request) do
      delete "/api/v1/household_accounts/#{household_account_id}",
           headers: headers
    end

    let(:headers) { nil }

    let(:user) { create(:user) }
    let(:household_account_id) { household_account.id }
    let(:household_account) { create(:household_account) }

    it_behaves_like 'authenticating user'

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:authenticated_user) { user }
      let(:headers) { authentication_headers }

      before do
        allow(HouseholdAccountPolicy)
          .to receive(:new)
          .and_return(household_account_policy_double)
      end

      let(:household_account_policy_double) do
        instance_double(HouseholdAccountPolicy,
                        destroy?: true)
      end

      context 'when user can destroy household account' do
        before do
          allow(HouseholdAccountService::Delete)
            .to receive(:new)
            .with(household_account: household_account)
            .and_return(delete_service_double)
        end

        let(:delete_service_double) do
          instance_double(HouseholdAccountService::Delete,
                          call: delete_service_result)
        end

        let(:delete_service_result) { Dry::Monads::Result::Success.new(true) }

        it 'calls delete service', :aggregate_failures do
          expect(HouseholdAccountService::Delete).to receive(:new)
          expect(delete_service_double).to receive(:call)
          make_request
        end

        it_behaves_like 'returning status code', :no_content

        context 'when delete service ends with failure' do
          let(:delete_service_result) { Dry::Monads::Result::Failure.new(errors: error_messages) }
          let(:error_messages) { ['error'] }

          it_behaves_like 'returning error with proper error messages'
        end
      end

      context 'when user cannot destroy household account' do
        let(:household_account_policy_double) do
          instance_double(HouseholdAccountPolicy,
                          destroy?: false)
        end

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when household account with given id cannot be found' do
        let(:household_account_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
