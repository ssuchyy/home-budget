# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::V1::User, type: :entity do
  subject(:entity) { described_class.new(user) }

  let(:user) { create(:user) }

  it 'exposes only allowed columns', :aggregate_failures do
    expect(entity_json).to have_key('id')
    expect(entity_json).to have_key('email')
    expect(entity_json.length).to eq(2)
  end
end
