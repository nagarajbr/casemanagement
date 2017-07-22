class AlterAssessmentBarriers1 < ActiveRecord::Migration
  def change
  	add_column :assessment_barriers, :assessment_section_id, :integer

  end
end
