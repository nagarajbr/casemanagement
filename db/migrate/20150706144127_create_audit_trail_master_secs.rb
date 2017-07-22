class CreateAuditTrailMasterSecs < ActiveRecord::Migration
  def change
    create_table :audit_trail_master_secs do |t|
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
      t.decimal :contract_amt, precision: 8, scale: 2, null: false
      t.integer :intended_use_mos
	    t.date :effective_beg_date
      t.integer :frequency
      t.integer :exp_calc_months
      t.date :effective_end_date
      t.string :created_by , null:false
      t.string :updated_by , null:false
      t.timestamps
    end
  end
end
