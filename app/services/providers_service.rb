class ProvidersService
	def self.create_provider_and_notes(arg_provider_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_provider_object.save!
				# Make entry into employer - if type is business
				Provider.update_branch_office_with_head_provider_id(arg_provider_object.id)
				if arg_provider_object.provider_type == 6139 && Provider.provider_not_present_in_employer(arg_provider_object.tax_id_ssn)
					@employer = Employer.new
					@employer.federal_ein = arg_provider_object.tax_id_ssn
					@employer.employer_name = arg_provider_object.provider_name
					@employer.employer_contact = arg_provider_object.contact_person
					@employer.save!
				end
				# Add notes if notes is present
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = provider
	                                        arg_provider_object.id, # entity_id = Client id
	                                        6505,  # notes_type = provider
	                                        arg_provider_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
	            # Queue functionality
        		queue_collection = WorkQueue.where("state = 6580 and reference_type = 6173 and reference_id = ?",arg_provider_object.id)
				if queue_collection.present?
					ls_msg = "SUCCESS"
				else
					#  1.Create queue
					#  2.save intake_worker_id
					# step1 : Populate common event management argument structure
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
					common_action_argument_object.event_id = 537 # Save Button
		            common_action_argument_object.queue_reference_type = 6173 # Provider
		            common_action_argument_object.queue_reference_id = arg_provider_object.id
		            common_action_argument_object.queue_worker_id = AuditModule.get_current_user.uid
		            # step2: call common method to process event.
		            ls_msg = EventManagementService.process_event(common_action_argument_object)
				end
			end
			if ls_msg == "SUCCESS"
				return arg_provider_object
            else
            	return ls_msg
            end
	        rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("ProvidersService","create_provider_and_notes",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to create provider - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.update_provider_and_notes(arg_provider_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				msg = trigger_events_for_provider_attr_changes(arg_provider_object)
				# arg_provider_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = Client
	                                        arg_provider_object.id, # entity_id = Client id
	                                        6505,  # notes_type = client
	                                        arg_provider_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            else
	            	# delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6151,arg_provider_object.id,6505,arg_provider_object.id)
	            end
			end
			return arg_provider_object
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Provider-Model","update_provider_and_notes",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to update provider - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.create_provider_branch_and_notes(arg_provider_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_provider_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = provider
	                                        arg_provider_object.id, # entity_id = Client id
	                                        6505,  # notes_type = provider
	                                        arg_provider_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
			end
			return arg_provider_object
	        rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Provider-Model","create_provider_branch_and_notes",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to create provider branch - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.update_provider_branch_and_notes(arg_provider_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_provider_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = Client
	                                        arg_provider_object.id, # entity_id = Client id
	                                        6505,  # notes_type = client
	                                        arg_provider_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            else
	            	# delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6151,arg_provider_object.id,6505,arg_provider_object.id)
	            end
			end
			return arg_provider_object
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Provider-Model","update_provider_branch_and_notes",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to update provider branch - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.trigger_events_for_provider_attr_changes(arg_provider_object)
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
		common_action_argument_object.provider_id = arg_provider_object.id
    	common_action_argument_object.model_object = arg_provider_object
    	common_action_argument_object.entity_type = 6151 # "Provider"
    	common_action_argument_object.changed_attributes = arg_provider_object.changed_attributes().keys
    	common_action_argument_object.is_a_new_record = arg_provider_object.new_record?
    	arg_provider_object.save!
		msg = EventManagementService.process_event(common_action_argument_object)
		return msg
	end

end