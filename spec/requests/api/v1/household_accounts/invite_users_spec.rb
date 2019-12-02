# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::HouseholdAccounts::InviteUsers, type: :request do
  describe 'api/v1/household_accounts/:id/invite_users' do
    subject(:make_request) do
      post "/api/v1/household_accounts/#{household_account_id}/invite_users",
           params: params, headers: headers
    end

    let(:params) { { emails: emails } }
    let(:headers) { nil }

    let(:emails) { ['asd@example.com', 'dsa@example.com'] }

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
                        manage?: true)
      end

      context 'when user can manage household account' do
        before do
          allow(HouseholdAccountService::InviteUsers)
            .to receive(:new)
            .with(household_account: household_account, users_emails: emails)
            .and_return(invite_users_service_double)
        end

        let(:invite_users_service_double) do
          instance_double(HouseholdAccountService::InviteUsers,
                          call: invite_users_service_result)
        end

        let(:invite_users_service_result) { Dry::Monads::Result::Success.new(true) }

        it 'calls invite users service' do :aggregate_failures
          expect(HouseholdAccountService::InviteUsers).to receive(:new)
          expect(invite_users_service_double).to receive(:call)
          subject
        end

        it_behaves_like 'returning status code', :no_content
      end

      context 'when user cannot manage household account' do
        let(:household_account_policy_double) do
          instance_double(HouseholdAccountPolicy,
                          manage?: false)
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
