# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::V1::Budget, type: :entity do
  subject(:entity) { described_class.new(budget) }

  let(:budget) { create(:budget) }

  it 'exposes only allowed columns', :aggregate_failures do
    expect(entity_json).to have_key('id')
    expect(entity_json).to have_key('name')
    expect(entity_json).to have_key('limit')
    expect(entity_json).to have_key('household_account_id')
    expect(entity_json.length).to eq(4)
  end
end
