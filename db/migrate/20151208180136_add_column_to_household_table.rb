class AddColumnToHouseholdTable < ActiveRecord::Migration
  def change
  	add_column :households, :intake_worker_id, :string
  	add_column :households, :processing_location_id, :integer
  end
end
