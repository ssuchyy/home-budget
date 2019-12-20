# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::V1::Budget, type: :entity do
  subject(:entity) { described_class.new(budget) }

  let(:budget) { create(:budget) }
  let(:calculate_remaining_service_double) do
    instance_double(BudgetService::CalculateRemaining,
                    call: Dry::Monads::Success.new(remaining: calculated_remaining))
  end
  let(:calculated_remaining) { 50 }

  before do
    allow(BudgetService::CalculateRemaining)
      .to receive(:new)
      .with(budget: budget)
      .and_return(calculate_remaining_service_double)
  end

  it 'exposes only allowed columns', :aggregate_failures do
    expect(entity_json).to have_key('id')
    expect(entity_json).to have_key('name')
    expect(entity_json).to have_key('limit')
    expect(entity_json).to have_key('remaining')
    expect(entity_json).to have_key('household_account_id')
    expect(entity_json.length).to eq(5)
  end

  it 'exposes remaining value as result of calcualte remaining service' do
    expect(entity_json['remaining']).to eq(calculated_remaining)
  end
end
