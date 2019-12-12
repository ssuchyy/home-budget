class CreateBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :budgets do |t|
      t.string :name
      t.decimal :limit, null: false, default: 0

      t.timestamps
    end
  end
end
