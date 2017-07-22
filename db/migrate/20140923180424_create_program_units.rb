class CreateProgramUnits < ActiveRecord::Migration
  def change
    create_table :program_units do |t|
      t.references :client_application, index: true, null:false
      t.integer :service_program_id, null: false
      t.integer :processing_location
      t.date :certfication_begin_date
      t.date :certfication_end_date
      t.integer :disposition_status
      t.integer :disposition_reason
      t.date    :disposition_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
