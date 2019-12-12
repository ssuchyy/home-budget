class Budget < ApplicationRecord
  belongs_to :household_account

  validates :name, presence: true, uniqueness: { scope: :household_account_id }
end
