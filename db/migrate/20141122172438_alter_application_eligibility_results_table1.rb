class AlterApplicationEligibilityResultsTable1 < ActiveRecord::Migration
  def change
  	change_column :application_eligibility_results, :data_item_type, 'integer USING CAST(data_item_type AS integer)'
  end
end
