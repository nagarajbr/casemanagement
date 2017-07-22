class AlterCareerPathwayPlans5 < ActiveRecord::Migration
  def change
  	add_column :career_pathway_plans, :core_hours, :integer
    add_column :career_pathway_plans, :non_core_hours, :integer
    add_column :career_pathway_plans, :other_hours, :integer
    add_column :career_pathway_plans, :supportive_services_hours, :integer
  end
end
