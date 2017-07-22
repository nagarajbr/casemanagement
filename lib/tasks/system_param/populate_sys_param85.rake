namespace :populate_sys_param85 do
	desc "adding assessment sections"
	task :add_short_assessments_sections => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)



		SystemParam.where("id = 1405 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '18',description: 'Testing Service')
		SystemParam.where("id = 1406 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '13',description: 'Transportation')
		SystemParam.where("id = 1407 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '4',description: 'Housing')
		SystemParam.where("id = 1408 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '8',description: 'General Health')
		SystemParam.where("id = 1409 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '10',description: 'Mental Health')
		SystemParam.where("id = 1410 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '9',description: 'Substance Abuse')
		SystemParam.where("id = 1411 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '11',description: 'Domestic Violence - Safety')
		SystemParam.where("id = 1412 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '5',description: 'Pregnancy')
		SystemParam.where("id = 1413 and system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS'").update_all(value: '6',description: 'Child Care and Parenting')

		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"2",description:"Employment")

	end
end