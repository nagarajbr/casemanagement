class CreateProgramUnitStateTransitions < ActiveRecord::Migration
  def change
    create_table :program_unit_state_transitions do |t|
      # t.references :program_unit, index: true
      t.integer :program_unit_id
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
      t.integer :created_by
      t.string :reason
    end
    add_index(:program_unit_state_transitions, :program_unit_id, name: "index_program_unit_id_st_trns")
  end
end
