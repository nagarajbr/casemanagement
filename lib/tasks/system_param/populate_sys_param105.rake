namespace :populate_sys_param105 do
	desc "work task manual create and manual closed tasks "
	task :Work_task_manual_created_manual_close => :environment do
	# manual create and manual close
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"6622",description:"Approve service payment amount above threshold",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"6606",description:"Employment Detail",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"6530",description:"Client Characteristics Information Changed",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2177",description:"SERVICE MANAGER-CHAR",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2176",description:"Assign different user to program unit",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2175",description:"TEA SANCTION",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2174",description:"Job Retention -Transfer",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2173",description:"Client Information Changed",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2171",description:"SSI Termination",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2170",description:"SERVICE CASE REFERRAL",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2169",description:"SSI New Case Match",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2167",description:"Case Error",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2166",description:"Notice Rejection",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2164",description:"Quarterly Wage",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2163",description:"Annual Review",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2162",description:"On-line Application Review",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2161",description:"Child Support Non-Coop",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2160",description:"Monthly Unemployment",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2159",description:"Medical Review Team",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2157",description:"Job Retention - Review",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2156",description:"Internal Revenue Match",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2153",description:"SERVICE MANAGER-EMPLOY",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2152",description:"Death Match",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2151",description:"Deferral/Exemption Follow",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2150",description:"Work Pays Case Change",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2149",description:"Child Support Exceed Grant",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2148",description:"CS Non-Coop-Budget Error",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2147",description:"Case Change",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2146",description:"Critical Age",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2145",description:"Income Mismatch",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2141",description:"Application Follow Up",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2139",description:"Case Ineligible Error",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"2138",description:"Eligibility Warning Follow up",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"6738",description:"Other",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"MANUAL_CREATED_MANUAL_CLOSE",value:"6774",description:"Other",created_by: 1,updated_by: 1)

	end
end

