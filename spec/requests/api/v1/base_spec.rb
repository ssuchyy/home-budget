# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeBudget::V1::Base, type: :request do
  describe 'expenses' do
    describe 'index' do
      subject { get '/api/v1/expenses', params: params }

      context 'with motto param' do
        let(:params) { { motto: 'motto' } }

        it 'returns 200 http code' do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context 'without motto param' do
        let(:params) { nil }

        it 'returns 400 http code' do
          subject
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
