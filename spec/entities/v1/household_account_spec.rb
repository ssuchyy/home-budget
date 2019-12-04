# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::V1::HouseholdAccount, type: :entity do
  subject(:entity) { described_class.new(household_account) }

  let(:household_account) { create(:household_account) }

  it 'exposes only allowed columns', :aggregate_failures do
    expect(entity_json).to have_key('id')
    expect(entity_json).to have_key('name')
    expect(entity_json).to have_key('users')
    expect(entity_json.length).to eq(3)
  end

  context 'with household with different users' do
    let(:user_created_by_api) { create(:user) }
    let(:user_with_accepted_invitation) { create(:invited_user, :with_accepted_invitation) }
    let(:user_with_pending_invitation) { create(:invited_user) }

    let(:users_ids) { entity_json['users'].map { |user| user['id'] } }

    before do
      household_account.users << [
        user_created_by_api,
        user_with_accepted_invitation,
        user_with_pending_invitation
      ]
    end

    it 'exposes users created by api' do
      expect(users_ids).to include(user_created_by_api.id)
    end

    it 'exposes users created by invitation with accepted invitation' do
      expect(users_ids).to include(user_with_accepted_invitation.id)
    end

    it 'does not expose users created by invitation with pending invitation' do
      expect(users_ids).to_not include(user_with_pending_invitation.id)
    end
  end
end
