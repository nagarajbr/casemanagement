class CreateIncomeDetailAdjustReasons < ActiveRecord::Migration
  def change
    create_table :income_detail_adjust_reasons do |t|
      t.references :income_detail, index: true
      t.decimal :adjusted_amount, precision: 8, scale: 2
      t.integer :adjusted_reason
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
