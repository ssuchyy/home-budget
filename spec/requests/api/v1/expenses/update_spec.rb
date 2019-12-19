# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Expenses::Update, type: :request do
  describe 'patch api/v1/expenses/:id' do
    subject(:make_request) do
      patch "/api/v1/expenses/#{expense_id}",
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
    let(:expense) { create(:expense) }
    let(:expense_id) { expense.id }

    it_behaves_like 'authenticating user'

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:authenticated_user) { user }
      let(:headers) { authentication_headers }

      before do
        allow(ExpensePolicy)
          .to receive(:new)
          .and_return(expense_policy_double)
      end

      let(:expense_policy_double) { instance_double(ExpensePolicy, update?: true) }

      context 'when user can update budget' do
        before do
          allow(ExpenseService::Update)
            .to receive(:new)
            .with(expense: expense, expense_params: { amount: amount })
            .and_return(update_service_double)
        end

        let(:update_service_double) do
          instance_double(ExpenseService::Update,
                          call: update_service_result)
        end

        let(:update_service_result) { Dry::Monads::Result::Success.new(object: updated_expense) }
        let(:updated_expense) do
          build_stubbed(:expense, amount: amount)
        end

        it 'calls expense update service', :aggregate_failures do
          expect(ExpenseService::Update)
            .to receive(:new)
            .with(expense: expense, expense_params: { amount: amount })
          expect(update_service_double).to receive(:call)
          make_request
        end

        it_behaves_like 'returning status code', :ok

        it 'returns updated expense', :aggregate_failures do
          make_request
          expect(response_body['id']).to eq(updated_expense.id)
          expect(response_body['amount']).to eq(amount.to_d.to_s)
        end
      end

      context 'when user cannot update expense' do
        let(:expense_policy_double) do
          instance_double(ExpensePolicy,
                          update?: false)
        end

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when expense with given id cannot be found' do
        let(:expense_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
