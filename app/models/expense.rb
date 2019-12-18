# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :household_account

  validates :amount, presence: true, numericality: { greater_than: 0 }
end
