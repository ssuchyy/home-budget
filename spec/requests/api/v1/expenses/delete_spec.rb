# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Expenses::Delete, type: :request do
  describe 'delete api/v1/expenses/:id' do
    subject(:make_request) do
      delete "/api/v1/expenses/#{expense_id}",
             headers: headers
    end

    let(:headers) { nil }

    let(:user) { create(:user) }
    let(:expense_id) { expense.id }
    let(:expense) { create(:expense) }

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

      let(:expense_policy_double) { instance_double(ExpensePolicy, destroy?: true) }

      context 'when user can destroy expense' do
        before do
          allow(ExpenseService::Delete)
            .to receive(:new)
            .with(expense: expense)
            .and_return(delete_service_double)
        end

        let(:delete_service_double) do
          instance_double(ExpenseService::Delete,
                          call: delete_service_result)
        end

        let(:delete_service_result) { Dry::Monads::Result::Success.new(true) }

        it 'calls delete service', :aggregate_failures do
          expect(ExpenseService::Delete).to receive(:new)
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

      context 'when user cannot destroy expense' do
        let(:expense_policy_double) { instance_double(ExpensePolicy, destroy?: false) }

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when expense with given id cannot be found' do
        let(:expense_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
