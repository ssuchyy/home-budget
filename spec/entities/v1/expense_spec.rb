# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::V1::Expense, type: :entity do
  subject(:entity) { described_class.new(expense) }

  let(:expense) { create(:expense) }

  it 'exposes only allowed columns', :aggregate_failures do
    expect(entity_json).to have_key('id')
    expect(entity_json).to have_key('amount')
    expect(entity_json).to have_key('budget_id')
    expect(entity_json.length).to eq(3)
  end
end
