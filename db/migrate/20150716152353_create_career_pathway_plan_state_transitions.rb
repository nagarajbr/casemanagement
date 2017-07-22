class CreateCareerPathwayPlanStateTransitions < ActiveRecord::Migration
  def change
    create_table :career_pathway_plan_state_transitions do |t|
      # t.references :career_pathway_plan, index: true
      t.integer :career_pathway_plan_id
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index(:career_pathway_plan_state_transitions, :career_pathway_plan_id, name: "index_cpp_id_st_trns")
  end
end
