class CreateChangeHouseholdAddressProcesses < ActiveRecord::Migration
  	def change
	    create_table :change_household_address_processes do |t|
		    t.integer :household_id
		    t.integer :current_address_id
		    t.integer :new_address_id
		    t.string  :process_completed, limit: 1
	        t.timestamps
	    end
    end
end
