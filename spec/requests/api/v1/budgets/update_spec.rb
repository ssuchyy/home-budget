# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Budgets::Update, type: :request do
  describe 'patch api/v1/household_accounts/:id/budgets/:id' do
    subject(:make_request) do
      patch "/api/v1/budgets/#{budget_id}",
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
    let(:budget) { create(:budget) }
    let(:budget_id) { budget.id }

    it_behaves_like 'authenticating user'

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:authenticated_user) { user }
      let(:headers) { authentication_headers }

      before do
        allow(BudgetPolicy)
          .to receive(:new)
          .and_return(budget_policy_double)
      end

      let(:budget_policy_double) do
        instance_double(BudgetPolicy,
                        update?: true)
      end

      context 'when user can update budget' do
        before do
          allow(BudgetService::Update)
            .to receive(:new)
            .with(budget: budget, budget_params: { name: name, limit: limit })
            .and_return(update_service_double)
        end

        let(:update_service_double) do
          instance_double(BudgetService::Update,
                          call: update_service_result)
        end

        let(:update_service_result) { Dry::Monads::Result::Success.new(object: updated_budget) }
        let(:updated_budget) do
          build_stubbed(:budget, name: name, limit: limit)
        end

        it 'calls budget update service', :aggregate_failures do
          expect(BudgetService::Update).to receive(:new)
          expect(update_service_double).to receive(:call)
          make_request
        end

        it_behaves_like 'returning status code', :ok

        it 'returns updated created budget', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(updated_budget.id)
          expect(response_body['name']).to eq(name)
          expect(response_body['limit']).to eq(limit.to_d.to_s)
        end
      end

      context 'when user cannot manage household account' do
        let(:budget_policy_double) do
          instance_double(BudgetPolicy,
                          update?: false)
        end

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when budget with given id cannot be found' do
        let(:budget_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
