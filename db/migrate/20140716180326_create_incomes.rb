class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
    t.integer :incometype, null: false
    t.decimal :amount, precision: 8, scale: 2
    t.integer :frequency
    t.integer :classification
    t.text    :source, limit: 35
	t.date    :effective_beg_date
	t.date    :effective_end_date
	t.text	  :notes , limit: 255
	t.string  :verified , limit: 1
    t.decimal :contract_amt, precision: 8, scale: 2
    t.integer :intended_use_mos
    t.date    :inc_avg_beg_date
    t.string  :recal_ind, limit: 1
    t.integer :created_by , null:false
    t.integer :updated_by , null:false
    t.timestamps
    end
  end
end