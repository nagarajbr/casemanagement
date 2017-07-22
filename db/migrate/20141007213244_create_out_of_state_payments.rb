class CreateOutOfStatePayments < ActiveRecord::Migration
  def change
    create_table :out_of_state_payments do |t|
    	t.integer :client_id
    	t.date    :payment_month
    	t.integer :work_participation_status
        t.integer :created_by , null:false
	    t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
