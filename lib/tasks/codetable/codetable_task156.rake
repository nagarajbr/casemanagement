namespace :populate_codetable156 do
	desc "additional work flow status "
	task :additional_work_flow_status => :environment do

		CodetableItem.create(code_table_id:160,short_description:"Authorized",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:160,short_description:"Authorization Rejected",long_description:"Authorization Rejected",system_defined:"FALSE",active:"TRUE")
		CodetableItem.where("code_table_id = 160 and id = 6167").update_all("short_description = 'Approval Rejected',long_description = 'Approval Rejected'")
		CodeTable.where("id = 160").update_all("name = 'Common status codes',description = 'work flow status and provider agreement status'")

	end
end