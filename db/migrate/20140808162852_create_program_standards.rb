class CreateProgramStandards < ActiveRecord::Migration
  def change
    create_table :program_standards do |t|
      t.text      :program_standard_name,limit:25
      t.text      :program_standard_description,limit:50
      t.string    :program_standard_unit_of_measurement,limit:1
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
