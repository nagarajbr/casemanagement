class CreateInStatePayments < ActiveRecord::Migration
  def change
    create_table :in_state_payments do |t|
    	t.integer :program_unit_id
    	t.integer :client_id
    	t.date    :payment_month
    	t.date    :issue_date
    	t.decimal :dollar_amount, precision: 8, scale: 2
    	t.date    :action_date
    	t.date    :action_type
    	t.string  :sanction, limit:1
    	t.integer :payment_type
    	t.integer :work_participation_status
    	t.date    :available_date
    	t.decimal :recoup_amount, precision: 8, scale: 2
        t.integer :created_by , null:false
	    t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
