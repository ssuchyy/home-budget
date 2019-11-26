class AddHousheholdAccountRefToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :household_account, foreign_key: true
  end
end
