namespace :populate_codetable219 do
	desc "adding other characteristic information changed entry and residency information entry to work order types"
	task :adding_other_characteristic_type_and_residency_ed_reason => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Other Characteristic No School Attendance Information Changed",long_description:"Other Characteristic No School Attendance Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Residency Information Changed",long_description:"Residency Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end