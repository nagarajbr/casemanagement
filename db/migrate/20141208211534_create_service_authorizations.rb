class CreateServiceAuthorizations < ActiveRecord::Migration
  def change
    create_table :service_authorizations do |t|
      t.references :provider, index: true, null: false
      t.references :program_unit, index: true, null: false
      t.references :client, index: true, null: false
      t.integer :activity_id,  null: false
      t.date    :service_start_date, null: false
      t.date    :service_end_date, null: false
      t.string :trip_start_address_line1, limit: 50
      t.string :trip_start_address_line2, limit: 50
      t.string :trip_start_address_city, limit: 50
      t.integer :trip_start_address_state
      t.string :trip_start_address_zip, limit: 5
      t.string :trip_end_address_line1, limit: 50
      t.string :trip_end_address_line2, limit: 50
      t.string :trip_end_address_city, limit: 50
      t.integer :trip_end_address_state
      t.string :trip_end_address_zip, limit: 5
      t.integer :outcome_achieved
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
