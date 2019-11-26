class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :household_accounts do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
