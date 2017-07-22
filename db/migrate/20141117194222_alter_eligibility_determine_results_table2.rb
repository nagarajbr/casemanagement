class AlterEligibilityDetermineResultsTable2 < ActiveRecord::Migration
  def up
  	add_column :eligibility_determine_results, :message_type_text, :string, limit: 25
  end
end
