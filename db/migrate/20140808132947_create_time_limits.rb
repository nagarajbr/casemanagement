class CreateTimeLimits < ActiveRecord::Migration
  def change
    create_table :time_limits do |t|
      t.references :client, index: true,null:false
      t.integer    :federal_count
      t.integer    :tea_state_count
      t.integer    :work_pays_state_count
      t.integer    :skip_count
      t.integer    :out_of_state_count
      t.date	     :payment_date, null:false
      t.date       :issue_date
      t.decimal    :payment_amount, precision: 8, scale: 2
      t.integer    :payment_type
      t.integer    :work_participation_reason, null:false
      t.integer    :state, null:false
      t.integer    :budget_unit_id
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
