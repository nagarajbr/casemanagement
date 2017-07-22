class CreateAuditTrailResDetailSecs < ActiveRecord::Migration
  def change
    create_table :audit_trail_res_detail_secs do |t|
      t.references :audit_trail_masters, index: true, null:false
      t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.integer :b_details_sequence, null: false
      t.decimal :resource_value, precision: 8, scale: 2
      t.date :resource_valued_date
      t.decimal :first_of_month_value, precision: 8, scale: 2
      t.integer :res_value_basis
      t.decimal :res_ins_face_value, precision: 8, scale: 2
      t.decimal :amount_owned_on_resource, precision: 8, scale: 2
      t.date :amount_owned_as_of_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
