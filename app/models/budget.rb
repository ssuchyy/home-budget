class Budget < ApplicationRecord
  PREDEFINED_BUDGETS_NAMES = %w[house car food university entertainment].freeze

  belongs_to :household_account

  validates :name, presence: true, uniqueness: { scope: :household_account_id }
end
