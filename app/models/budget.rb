# frozen_string_literal: true

class Budget < ApplicationRecord
  PREDEFINED_BUDGETS_NAMES = %w[house car food university entertainment].freeze

  belongs_to :household_account
  has_many :expenses, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :household_account_id }
end
