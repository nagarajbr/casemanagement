class CreateExpenseDetails < ActiveRecord::Migration
  def change
    create_table :expense_details do |t|
      t.references :expense, index: true
      t.date :expense_due_date
      t.decimal :expense_amount, precision: 8, scale: 2
      t.integer :expense_use_code
      t.integer :payment_method
      t.integer :payment_status
      t.string  :expense_calc_ind, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
