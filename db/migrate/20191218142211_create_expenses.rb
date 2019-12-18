class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|

      t.decimal :amount

      t.timestamps
    end

    add_reference :expenses, :budget, foreign_key: true
  end
end
