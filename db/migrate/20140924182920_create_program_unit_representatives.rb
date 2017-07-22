class CreateProgramUnitRepresentatives < ActiveRecord::Migration
  def change
    create_table :program_unit_representatives do |t|
      t.references :program_unit, index: true, null:false
      t.references :client, index: true, null:false
      t.integer :type
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
