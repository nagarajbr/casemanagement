class CreateProgramUnitMembers < ActiveRecord::Migration
  def change
    create_table :program_unit_members do |t|
     t.references :program_unit, index: true, null:false
      t.integer :client_id
      t.integer :member_status
      t.string    :member_of_application, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
    end
  end

