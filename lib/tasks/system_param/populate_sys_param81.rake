namespace :populate_sys_param81 do
	desc "Various assessment sections"
	task :short_assessments_sections => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"3",description:"Education",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"13",description:"Transportation",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"4",description:"Housing",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"8",description:"General Health",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"10",description:"Mental Health",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"9",description:"Substance Abuse",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"11",description:"Domestic Violence - Safety",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"5",description:"Pregnancy",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"6",description:"Child Care and Parenting",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"2",description:"Employment",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"SHORT_ASSESSMENT_SECTIONS",value:"132",description:"Assessments",created_by:1,updated_by: 1)

	end
end
