class CreatePrescreenHouseholdResults < ActiveRecord::Migration
  def change
    create_table :prescreen_household_results do |t|
    	t.references :prescreen_household,null: false, index: true
    	t.integer :service_program_category_id,null: false
    	t.string :result_description, limit: 255

      t.timestamps
    end
  end
end
