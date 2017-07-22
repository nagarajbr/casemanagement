namespace :populate_codetable256 do
	desc "Queue Name Changes "
	task :queue_name_changes  => :environment do
		CodetableItem.where("code_table_id = 196 and id = 6557").update_all(short_description: 'Ready for Application Processing',long_description:'Application Screening',sort_order:10)
		CodetableItem.where("code_table_id = 196 and id = 6558").update_all(short_description: 'Ready for Eligibility Determination',long_description:'Ready for Eligibility Determination',sort_order:20)
		CodetableItem.where("code_table_id = 196 and id = 6559").update_all(short_description: 'Ready for Work Readiness Assessment',long_description:'Ready for Work Readiness Assessment',sort_order:30)
		CodetableItem.where("code_table_id = 196 and id = 6560").update_all(short_description: 'Ready for Employment Readiness planning',long_description:'Ready for Employment Readiness planning',sort_order:40)
		CodetableItem.where("code_table_id = 196 and id = 6637").update_all(short_description: 'Ready for Career Planning Approval',long_description:'Ready for Career Pathway Planning Approval',sort_order:50)
		CodetableItem.where("code_table_id = 196 and id = 6562").update_all(short_description: 'Ready for Program Unit Activation',long_description:'Ready for Program Unit Activation',sort_order:60)
		CodetableItem.where("code_table_id = 196 and id = 6616").update_all(short_description: 'Active Program Units',long_description:'Active Program Units',sort_order:70)


		# approval rejected changed to rejected
		CodetableItem.where("code_table_id = 160 and id = 6167").update_all(short_description: 'Rejected',long_description:'Rejected')
	end
end