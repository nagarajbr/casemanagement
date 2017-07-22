class AlterClientAssessment4 < ActiveRecord::Migration
  def change
  	add_column :client_assessments, :review_date,"date"
  end
end
