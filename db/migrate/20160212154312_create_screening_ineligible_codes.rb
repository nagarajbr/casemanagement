class CreateScreeningIneligibleCodes < ActiveRecord::Migration
  def change
    create_table :screening_ineligible_codes do |t|
     	t.integer :application_id, null:false
    	t.integer :service_program, null:false
    	t.integer :ineligible_codes, array:true, null:false
    	t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
