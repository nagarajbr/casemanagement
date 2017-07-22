class EventManagementService
	def self.process_event(arg_object)
		ls_message = nil
		if arg_object.model_object.present?
			arg_object.changed_attributes.each  do |attribute|
				model_name = arg_object.model_object.class.name
            	ruby_element_id = RubyElement.get_ruby_element_id_for_field(model_name, attribute)
            	if ruby_element_id.present?
            		arg_object.event_id = ruby_element_id
            		ls_message = EventManagementService.execute_event(arg_object)
            		if ls_message != "SUCCESS"
	                    break
	                end
            	end
            end
      	else
			ls_message = execute_event(arg_object)
		end
		return ls_message
	end

	def self.execute_event(arg_object)
		# Rails.logger.debug("MNP-event management common argument structure = #{arg_object.inspect}")
		# description :
		# 1.Get the List of Actions for the event.
		# 2.call service method to return object to be saved/error message
		# 3. If there are no errors in any one action - Save all objects in transaction and commit.
		ls_message = "SUCCESS"
		l_array = []
		li_event = arg_object.event_id
		events_to_action_collection = EventToActionsMapping.get_actions_list_for_event_id(li_event)
		# Rails.logger.debug("events_to_action_collection = #{events_to_action_collection.inspect}")
		# fail
		if events_to_action_collection.present?
        	begin
	            ActiveRecord::Base.transaction do
			        events_to_action_collection.each do |each_action|
			        	Rails.logger.debug("MNP- each_action = #{each_action.inspect}")
			        	# fail
			        	# Method to be called is stored in LOng description.
			            # l_value = each_action.value.to_i
			            # codetable_item_object = CodetableItem.find(l_value)
			            ls_dynamic_method = each_action.method_name
			            ls_array = ls_dynamic_method.split(".")
			            ls_class_name = ls_array[0]
			            ls_method_name = ls_array[1]
			            ls_class_name = ls_class_name.constantize
			            # This function returns hash with two values
			            # 1. Object to be saved
			            # 2. SUCCESS/ERROR MESSAGE
			            ls_class_name.method("#{ls_method_name}").call(arg_object,each_action)
			            # Rails.logger.debug("MNP- ls_class_name = #{ls_class_name} SUCCESS")
			            # fail
			        end
				end
	            ls_message = "SUCCESS"
         	rescue => err
               	error_object = CommonUtil.write_to_attop_error_log_table("EventManagementService - Service Class","process_event",err,AuditModule.get_current_user.uid)
               	ls_message = "Failed to process event - for more details refer to error ID: #{error_object.id}."
	        end
		else
			ls_message = "No actions found for this event."
		end
	    return ls_message
	end
end