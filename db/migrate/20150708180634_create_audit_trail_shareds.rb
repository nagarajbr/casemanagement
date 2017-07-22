class CreateAuditTrailShareds < ActiveRecord::Migration
  def change
    create_table :audit_trail_shareds do |t|
      t.references :audit_trail_masters, index: true, null:false
      t.references :clients, index: true, null:false
      t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.integer :b_details_sequence, null: false
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end

  end
end
