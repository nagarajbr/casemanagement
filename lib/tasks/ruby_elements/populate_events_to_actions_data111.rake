namespace :populate_events_to_actions_data111 do
	desc "adding action create task type for missing field changes on Income and Income Detail"
	task :populate_events_to_actions_data111 => :environment do
		# "Income"
		EventToActionsMapping.create(event_type:779, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:780, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:781, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:782, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:783, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Income Details"
		EventToActionsMapping.create(event_type:786, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:787, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:788, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:789, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Resource"
		EventToActionsMapping.create(event_type:793, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:794, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:795, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Resource Detail"
		EventToActionsMapping.create(event_type:796, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:797, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:798, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Resource Adjustment"
		EventToActionsMapping.create(event_type:799, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:800, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:801, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:802, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Resource Use"
		EventToActionsMapping.create(event_type:803, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Client - residency, dob, date of death"
		EventToActionsMapping.create(event_type:816, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:755, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:70, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:759, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.where("id = 251").update_all(enable_flag: 'N') # Duplicate alert action found

		# "ClientCharacteristic" - "characteristic_id", "start_date", "end_date"
		EventToActionsMapping.create(event_type:769, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:770, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:771, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "SanctionDetail" - "release_indicatior"
		EventToActionsMapping.create(event_type:825, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "Employment" - "effective_begin_date", "effective_end_date"
		EventToActionsMapping.create(event_type:791, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:792, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "EmploymentDetail" - "current_status", "effective_begin_date", "effective_end_date", "salary_pay_amt", "salary_pay_frequency", "hours_per_period"
		EventToActionsMapping.create(event_type:827, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:828, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:829, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:830, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:831, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:832, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# Action for Program Unit Submit button - 683
		EventToActionsMapping.where("id = 325").update_all(task_type: 2142)
		EventToActionsMapping.create(event_type: 683, action_type:6458, method_name:"WorkTaskService.complete_work_task", sort_order:40, task_type:6635 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "SanctionDetail" - "adding a new sanction"
		EventToActionsMapping.create(event_type:834, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:40, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "IncomeDetailAdjustReason - adjusted_amount"
		EventToActionsMapping.create(event_type:790, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')

		# "OutOfStatePayments - save"
		EventToActionsMapping.create(event_type:778, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:30, task_type:2142 ,created_by: 1,updated_by: 1, enable_flag: 'Y')
	end
end
