class CreateEmploymentDetails < ActiveRecord::Migration
  def change
    create_table :employment_details do |t|
      t.references :employment, index: true
      t.date       :effective_begin_date, null:false
      t.date       :effective_end_date
      t.integer    :hours_per_period, null:false
      t.decimal :salary_pay_amt, precision: 8, scale: 2, null:false
      t.integer :salary_pay_frequency, null:false
      t.integer :position_type
      t.integer :current_status, null:false
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
