class AlterCareerPathwayPlansAddPguId < ActiveRecord::Migration
  def change
  	 add_column :career_pathway_plans, :program_unit_id, :integer
  end
end
