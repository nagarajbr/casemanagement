class AlterTableCareerPathwayPlanStateTransitions < ActiveRecord::Migration
  def change
  	add_column :career_pathway_plan_state_transitions, :created_by, :integer
  	add_column :career_pathway_plan_state_transitions, :reason, :string
  end
end
