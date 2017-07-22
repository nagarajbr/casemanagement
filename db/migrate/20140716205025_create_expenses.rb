     class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|

    t.integer :expensetype, null: false
    t.decimal :amount, precision: 8, scale: 2
    t.date    :effective_beg_date
	  t.date    :effective_end_date
	  t.string  :creditor_name, limit: 35
	  t.string  :creditor_contact, limit: 35
	  t.string  :creditor_phone , limit: 10
    t.string  :creditor_ext , limit: 5
	  t.integer :payment_status
    t.integer :frequency
    t.integer :payment_method
    t.string  :verified , limit: 1
	  t.text	  :notes , limit: 255
	  t.integer :use_code
      t.integer :exp_calc_months
      t.string  :budget_recalc_ind, limit: 1
    t.integer :created_by , null:false
    t.integer :updated_by , null:false
    t.timestamps
    end
  end
end
