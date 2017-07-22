namespace :populate_events_to_actions_data31 do
	desc "event to action mappings entries for income_detail_adjust_reasons changes"
	task :populate_events_to_actions_data31 => :environment do
		type = 6368
		ruby_element = RubyElement.create(element_name:"IncomeDetailAdjustReason",element_title:"adjusted_amount", element_type: type, description:"Adjustment Amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income_detail_adjust_reasons",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end