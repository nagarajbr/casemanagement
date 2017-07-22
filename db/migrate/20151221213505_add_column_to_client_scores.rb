class AddColumnToClientScores < ActiveRecord::Migration
  def up
  	add_column :client_scores, :client_assessment_id, :integer
  end
end
