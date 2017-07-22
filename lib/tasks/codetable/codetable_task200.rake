namespace :populate_codetable200 do
	desc "adding OtherCharacteristic characteristic id"
	task :adding_other_characteristic_no_school_attendance => :environment do
		CodetableItem.create(code_table_id:112,short_description:"No school attendance",long_description:"No school attendance",type:"OtherCharacteristic",system_defined:"FALSE",active:"TRUE")
	end
end