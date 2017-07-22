class ClientAlienService
	def self.create_citizenship(arg_client_object,arg_alien_object,arg_notes)
	     msg = "SUCCESS"
	     begin
	        ActiveRecord::Base.transaction do
	        	Rails.logger.debug("arg_client_object = #{arg_client_object.inspect}")
	        	Rails.logger.debug("arg_alien_object = #{arg_alien_object.inspect}")
	        	if arg_client_object.citizenship == 'Y'
	        		arg_client_object.save!
	        		# fail
	        	else
	        		arg_client_object.save!
	        		arg_alien_object.save!
	        		ClientAlienService.process_actions_for_client_citizenship(arg_alien_object, arg_alien_object.client_id)
	        		# fail
	        	end


	          if arg_notes.present?
                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
                NotesService.save_notes(6150, # entity_type = Client
                                        arg_client_object.id, # entity_id = Client id
                                        6473,  # notes_type = Alien
                                        arg_client_object.id, # reference_id = income ID
                                        arg_notes) # notes
              end

	      end

	        msg = "SUCCESS"
	      rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("Alien-Model","save_citizenship",err,AuditModule.get_current_user.uid)
	          msg = "Failed to save citizenship information - for more details refer to error ID: #{error_object.id}."

	      end
	      return msg
  	end

  	def self.update_citizenship(arg_client_object,arg_alien_object,arg_notes)
	     msg = "SUCCESS"
	     begin
	        ActiveRecord::Base.transaction do
	        	msg = ClientDemographicsService.process_biographic_information_changes(arg_client_object)

	        	if arg_client_object.citizenship == 'Y'
	        		arg_client_object.save!
	        		if arg_alien_object.present?
	        			alient_object = Alien.where("client_id = ?",arg_alien_object.client_id)
	        			alient_object.destroy_all
	        		end
	        	else
	        		arg_client_object.save!
	        		arg_alien_object.save!
	        		ClientAlienService.process_actions_for_client_citizenship(arg_alien_object,arg_alien_object.client_id)
	        	end

	          	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_object.id, # entity_id = Client id
	                                        6473,  # notes_type = Alien
	                                        arg_client_object.id, # reference_id = income ID
	                                        arg_notes) # notes
              	else
	              	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_object.id,6473,arg_client_object.id)
              	end
	      	end

	        msg = "SUCCESS"
	      rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("ClientAlienService","update_citizenship",err,AuditModule.get_current_user.uid)
	          msg = "Failed to update citizenship information - for more details refer to error ID: #{error_object.id}."

	      end
	      return msg
  	end

  	def self.process_actions_for_client_citizenship(arg_client_citizenship_object, arg_client_id)
		msg = nil
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        common_action_argument_object.client_id = arg_client_id
	        common_action_argument_object.model_object = arg_client_citizenship_object
	        common_action_argument_object.program_unit_id = ProgramUnit.get_open_client_program_units(arg_client_id).first.id
	        common_action_argument_object.changed_attributes = arg_client_citizenship_object.changed_attributes().keys
	        common_action_argument_object.is_a_new_record = arg_client_citizenship_object.new_record?
			ls_msg = EventManagementService.process_event(common_action_argument_object)
        end
        arg_client_citizenship_object.save!
        return msg
	end
end