# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Budgets::Update, type: :request do
  describe 'get api/v1/budgets/:id' do
    subject(:make_request) do
      get "/api/v1/budgets/#{budget_id}",
          headers: headers
    end

    let(:headers) { nil }

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
                        show?: true)
      end

      context 'when user can view budget' do
        it_behaves_like 'returning status code', :ok

        it 'returns budget with given id', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(budget.id)
          expect(response_body['name']).to eq(budget.name)
          expect(response_body['limit']).to eq(budget.limit.to_s)
        end
      end

      context 'when user cannot view budget' do
        let(:budget_policy_double) do
          instance_double(BudgetPolicy,
                          show?: false)
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
