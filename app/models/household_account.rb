# frozen_string_literal: true

class HouseholdAccount < ApplicationRecord
  has_many :users

  validates :name, presence: true

  def active_users
    users.where(invitation_created_at: nil).or(users.where('invitation_accepted_at IS NOT NULL'))
  end
end
