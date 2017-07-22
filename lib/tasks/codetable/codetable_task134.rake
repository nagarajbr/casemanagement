namespace :populate_codetable134 do
	desc "clean up sanction types"
	task :clean_up_sanction_types => :environment do
		CodetableItem.where("code_table_id = 56 and id = 3082").update_all(short_description:"Class Attendance",long_description:"Class Attendance")
		CodetableItem.where("code_table_id = 56 and id = 6225").update_all(short_description:"Class Attendance-Minor Parent",long_description:"Class Attendance-Minor Parent")
		CodetableItem.where("code_table_id = 89").destroy_all
		CodeTable.where("id = 89").destroy_all
		# SystemParam.where("system_param_categories_id = 9 and key='BENEFIT_REDUCING_SANCTIONS' and value = '4578'").update_all(value:"3082")
		# SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"6349",description:"Refusal to sign PRA by minor parent sanction",created_by: 1,updated_by: 1)

	end
end



