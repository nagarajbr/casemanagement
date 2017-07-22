class AlterEligibilityDetermineResultsTable3 < ActiveRecord::Migration
  def change
  	change_column :eligibility_determine_results, :message, 'integer USING CAST(message AS integer)'
  	rename_column :eligibility_determine_results, :message, :message_type
  end
end
