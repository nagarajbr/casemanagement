class AlterTimeLimitsTable < ActiveRecord::Migration
  def up
  	rename_column :time_limits, :payment_date, :payment_month
  	
   	remove_column :time_limits, :issue_date
   	remove_column :time_limits, :payment_amount
   	remove_column :time_limits, :payment_type
   	remove_column :time_limits, :work_participation_reason
   	remove_column :time_limits, :state
   	remove_column :time_limits, :budget_unit_id

  end
end
