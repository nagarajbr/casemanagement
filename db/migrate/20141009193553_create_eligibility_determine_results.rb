class CreateEligibilityDetermineResults < ActiveRecord::Migration
  def change
    create_table :eligibility_determine_results do |t|
    	t.integer :run_id,null:false
    	t.integer :month_sequence,null:false
    	t.integer :program_unit_id,null:true
    	t.integer :client_id,null:true
    	t.string  :message,null:false
    	t.integer :created_by,null:false
    	t.integer :updated_by,null:false
    	t.timestamps
    end
  end
end
