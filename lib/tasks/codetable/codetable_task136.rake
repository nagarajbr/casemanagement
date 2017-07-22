namespace :populate_codetable136 do
	desc "action activity types"
	task :additional_activity_types => :environment do
		CodetableItem.create(code_table_id:181,short_description:"Provide Child Care Services for Participant Enrolled in Community Service",long_description:"Provide Child Care Services for Participant Enrolled in Community Service",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Submit Attendance record",long_description:"Submit Attendance record",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Refer to other agencies as applicable",long_description:"Refer to other agencies as applicable",system_defined:"FALSE",active:"TRUE")
    end
end