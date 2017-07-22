class AlterCareerPathwayPlans2 < ActiveRecord::Migration
  def change
  	add_column :career_pathway_plans, :update_communication_type, :integer
  end
end
