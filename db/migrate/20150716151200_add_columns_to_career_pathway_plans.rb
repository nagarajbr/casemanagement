class AddColumnsToCareerPathwayPlans < ActiveRecord::Migration
  def change
  	add_column :career_pathway_plans, :reason, :string
  	add_column :career_pathway_plans, :state, :integer
  end
end
