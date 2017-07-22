class CreateAuditTrailMasters < ActiveRecord::Migration
  def change
    create_table :audit_trail_masters,:id => false do |t|
      t.integer :id
      t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.integer :b_details_sequence, null: false
      t.text :audit_det_ind, limit: 1
      t.integer :client_id, null: false
      t.text :source, limit: 35
      t.integer :service_program_id, null: false
      t.integer :type, null: false
      t.integer :processing_location, null: false
      t.date :inc_avg_begin_date
      t.decimal :contract_amt, precision: 8, scale: 2
      t.integer :intended_use_mos
	    t.date :effective_beg_date
      t.integer :frequency
      t.integer :exp_calc_months
      t.date :effective_end_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end

    execute "ALTER TABLE audit_trail_masters ADD PRIMARY KEY (id)"

    execute "CREATE SEQUENCE audit_master_seq"
  end

end




