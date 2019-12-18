# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Expenses::Create, type: :request do
  describe 'post api/v1/budgets/:id/expenses' do
    subject(:make_request) do
      post "/api/v1/budgets/#{budget_id}/expenses",
           params: params, headers: headers
    end

    let(:params) do
      {
        amount: amount
      }
    end
    let(:headers) { nil }

    let(:amount) { 100 }

    let(:user) { create(:user) }
    let(:budget_id) { budget.id }
    let(:budget) { create(:budget) }

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

      let(:budget_policy_double) { instance_double(BudgetPolicy, update?: true) }

      context 'when user can update budget' do
        before do
          allow(ExpenseService::Create)
            .to receive(:new)
            .with(amount: amount, budget: budget)
            .and_return(create_service_double)
        end

        let(:create_service_double) do
          instance_double(ExpenseService::Create,
                          call: create_service_result)
        end

        let(:create_service_result) { Dry::Monads::Result::Success.new(object: expense) }
        let(:expense) { create(:expense, amount: amount, budget: budget) }

        it 'calls expense create service', :aggregate_failures do
          expect(ExpenseService::Create).to receive(:new)
          expect(create_service_double).to receive(:call)
          make_request
        end

        it_behaves_like 'returning status code', :created

        it 'returns newly created expense', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(Expense.last.id)
          expect(response_body['amount']).to eq(amount.to_d.to_s)
        end
      end

      context 'when user cannot update budget' do
        let(:budget_policy_double) { instance_double(BudgetPolicy, update?: false) }

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when budget with given id cannot be found' do
        let(:budget_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
