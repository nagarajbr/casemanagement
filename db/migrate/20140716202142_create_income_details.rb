class CreateIncomeDetails < ActiveRecord::Migration
  def change
    create_table :income_details do |t|
      t.references :income, index: true
      t.integer :check_type
      t.date    :date_received
      t.decimal :gross_amt, precision: 8, scale: 2
      t.decimal :adjusted_total, precision: 8, scale: 2
      t.decimal :net_amt, precision: 8, scale: 2
      t.string  :cnt_for_convert_ind, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
