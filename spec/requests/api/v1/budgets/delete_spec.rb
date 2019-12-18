# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Budgets::Delete, type: :request do
  describe 'delete api/v1/budgets/:id' do
    subject(:make_request) do
      delete "/api/v1/budgets/#{budget_id}",
             headers: headers
    end

    let(:headers) { nil }

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

      let(:budget_policy_double) { instance_double(BudgetPolicy, destroy?: true) }

      context 'when user can destroy budget' do
        before do
          allow(BudgetService::Delete)
            .to receive(:new)
            .with(budget: budget)
            .and_return(delete_service_double)
        end

        let(:delete_service_double) do
          instance_double(BudgetService::Delete,
                          call: delete_service_result)
        end

        let(:delete_service_result) { Dry::Monads::Result::Success.new(true) }

        it 'calls delete service', :aggregate_failures do
          expect(BudgetService::Delete).to receive(:new)
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

      context 'when user cannot destroy budget' do
        let(:budget_policy_double) { instance_double(BudgetPolicy, destroy?: false) }

        it_behaves_like 'returning 401 unauthorized response'
      end

      context 'when budget with given id cannot be found' do
        let(:budget_id) { 999 }

        it_behaves_like 'returning 404 not found response'
      end
    end
  end
end
