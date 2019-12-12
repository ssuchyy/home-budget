class AddHouseholdAccountRefToBudgets < ActiveRecord::Migration[5.2]
  def change
    add_reference :budgets, :household_account, foreign_key: true
  end
end
