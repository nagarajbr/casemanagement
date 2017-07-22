class CreateResourceAdjustments < ActiveRecord::Migration
  def change
    create_table :resource_adjustments do |t|
      t.references :resource_detail
      t.decimal :resource_adj_amt, precision: 8, scale: 2
      t.date :receipt_date
      t.integer :reason_code
      t.date :adj_begin_date
      t.date :adj_end_date
      t.integer :adj_num_of_months
       t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
