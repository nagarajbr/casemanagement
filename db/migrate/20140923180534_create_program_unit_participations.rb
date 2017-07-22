class CreateProgramUnitParticipations < ActiveRecord::Migration
  def change
    create_table :program_unit_participations do |t|
       t.references :program_unit, index: true, null:false
       t.integer :participation_status
       t.date :status_date
       t.date :action_date
       t.integer :reason
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
