# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Budgets::Create, type: :request do
  describe 'api/v1/household_accounts/:id/budgets/create' do
    subject(:make_request) do
      post "/api/v1/household_accounts/#{household_account_id}/budgets",
           params: params, headers: headers
    end

    let(:params) do
      {
        name: name,
        limit: limit
      }
    end
    let(:headers) { nil }

    let(:name) { FFaker::Product.brand }
    let(:limit) { 100 }

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
          allow(BudgetService::Create)
            .to receive(:new)
            .with(name: name, limit: limit, household_account: household_account)
            .and_return(create_service_double)
        end

        let(:create_service_double) do
          instance_double(BudgetService::Create,
                          call: create_service_result)
        end

        let(:create_service_result) { Dry::Monads::Result::Success.new(object: budget) }
        let(:budget) do
          create(:budget, name: name, limit: limit, household_account: household_account)
        end

        it 'calls budget create service', :aggregate_failures do
          expect(BudgetService::Create).to receive(:new)
          expect(create_service_double).to receive(:call)
          make_request
        end

        it_behaves_like 'returning status code', :created

        it 'returns newly created budget', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(Budget.last.id)
          expect(response_body['name']).to eq(name)
          expect(response_body['limit']).to eq(limit.to_d.to_s)
        end
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
