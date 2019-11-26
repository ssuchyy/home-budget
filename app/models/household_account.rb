# frozen_string_literal: true

class HouseholdAccount < ApplicationRecord
  has_many :users

  validates :name, presence: true
end
