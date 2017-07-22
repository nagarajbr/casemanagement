class ParentalResponsibilityService
	def self.create_client_parental_responsibility(arg_parent_rspability_object,arg_client_id,arg_notes)
			begin
	            ActiveRecord::Base.transaction do
	            	arg_parent_rspability_object.save!
	            	ls_msg = trigger_events_for_client_parental_rspabilities(arg_parent_rspability_object,arg_client_id)
	              	if arg_notes.present?
		                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
		                NotesService.save_notes(6150, # entity_type = Client
		                                        arg_client_id, # entity_id = Client id
		                                        6490,  # notes_type = parental responsibility
		                                        arg_parent_rspability_object.id, # reference_id = income ID
		                                        arg_notes) # notes
	              	end
	        	end
	            ls_msg = "SUCCESS"
	            rescue => err
	            	error_object = CommonUtil.write_to_attop_error_log_table("ParentalResponsibility-Model","create_client_parental_responsibility",err,AuditModule.get_current_user.uid)
	            	ls_msg = "Failed to save parental responsibility - for more details refer to error ID: #{error_object.id}."
         	end
          return ls_msg
	end

	def self.update_client_parental_responsibility(arg_parent_rspability_object,arg_client_id,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	        	arg_parent_rspability_object.save!
	        	ls_msg = trigger_events_for_client_parental_rspabilities(arg_parent_rspability_object,arg_client_id)
	          	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6490,  # notes_type = parental responsibility
	                                        arg_parent_rspability_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	          	# else
		          #   #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		          #   NotesService.delete_notes(6150,arg_client_id,6490,arg_parent_rspability_object.id)
	          	end
	        end
	        msg = "SUCCESS"
	         rescue => err
	             error_object = CommonUtil.write_to_attop_error_log_table("ParentalResponsibility-Model","update_client_parental_responsibility",err,AuditModule.get_current_user.uid)
	             msg = "Failed to update parental responsibility - for more details refer to error ID: #{error_object.id}."
      	end
	end

	def self.trigger_events_for_client_parental_rspabilities(arg_parent_rspability_object,arg_client_id)
      ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        common_action_argument_object.client_id = arg_client_id
	        common_action_argument_object.model_object = arg_parent_rspability_object
	        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
	        common_action_argument_object.changed_attributes = arg_parent_rspability_object.changed_attributes().keys
	        common_action_argument_object.is_a_new_record = arg_parent_rspability_object.new_record?
	        # arg_parent_rspability_object.save!
			ls_msg = EventManagementService.process_event(common_action_argument_object)
		# else
		# 	# fail
		# 	ls_msg = arg_parent_rspability_object.save! ? "SUCCESS" : "Cannot create employment information"
		end
      return ls_msg
    end


    def self.create_absent_parent_responsibility_data(arg_absent_parent_object,arg_child_client_ids_collection,arg_params,arg_notes,arg_household_id)
    	begin
            ActiveRecord::Base.transaction do
            	arg_child_client_ids_collection.each do |each_child_client_object|
            		# get the relationship id for absent parent and each child
            		parent_relations_collection = ClientRelationship.where("from_client_id = ? and to_client_id = ? and relationship_type = 5977",each_child_client_object.id,arg_absent_parent_object.id)
					if parent_relations_collection.present?
						parent_relation_object = parent_relations_collection.first

						# check if reposnsibility record exists for this relationship id
						# insert/update client responsibility record.
						absent_parent_responsibility_collection = ClientParentalRspability.where("client_relationship_id = ?",parent_relation_object.id)
						if absent_parent_responsibility_collection.present?
							# update operation
							absent_parent_responsibility_object = absent_parent_responsibility_collection.first
						else
							# insert operation
							absent_parent_responsibility_object = ClientParentalRspability.new
							absent_parent_responsibility_object.client_relationship_id = parent_relation_object.id
						end
						absent_parent_responsibility_object.parent_status = 6076 # absent
						absent_parent_responsibility_object.deprivation_code = arg_params[:deprivation_code]
						absent_parent_responsibility_object.good_cause = arg_params[:good_cause]
						absent_parent_responsibility_object.amount_collected = arg_params[:amount_collected] if arg_params[:amount_collected].present?
						absent_parent_responsibility_object.court_ordered_amount = arg_params[:court_ordered_amount] if arg_params[:court_ordered_amount].present?
						absent_parent_responsibility_object.married_at_birth = arg_params[:married_at_birth] if arg_params[:married_at_birth].present?
						absent_parent_responsibility_object.paternity_established = arg_params[:paternity_established] if arg_params[:paternity_established].present?
						absent_parent_responsibility_object.court_order_number = arg_params[:court_order_number] if arg_params[:court_order_number].present?
						absent_parent_responsibility_object.child_support_referral = arg_params[:child_support_referral] if arg_params[:child_support_referral].present?


						absent_parent_responsibility_object.save!
						# save notes if present
	            		if arg_notes.present?
			                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
			                NotesService.save_notes(6150, # entity_type = Client
			                                        arg_absent_parent_object.id, # entity_id = Client id
			                                        6490,  # notes_type = parental responsibility
			                                        absent_parent_responsibility_object.id, # reference_id =
			                                        arg_notes) # notes
		              	end
					else
						ls_msg = "Parent Relationship record not found between clients: #{arg_absent_parent_object.get_full_name} and #{each_child_client_object.get_full_name}."
					end
            	end # end of arg_child_client_ids_collection.each

            	# Manoj - 04/01/2016 - add this absent parent client id to household as 'out of household'
				household_member_object = HouseholdMember.set_household_member_data(arg_household_id,arg_absent_parent_object.id)
				household_member_object.member_status = 6644 # out of HOUSEHOLD STATUS
				household_member_object.save!

				# create a new household for this absent parent - so that if he wants to apply for benefits - he can proceed.
				# check to see if this absent parent client id is present 'in household'
				hh_member_in_household_collection = HouseholdMember.where("client_id = ? and member_status = 6643",arg_absent_parent_object.id)
				if hh_member_in_household_collection.blank?
					# proceed to create new household & household member for this absent parent
					new_household_object = Household.new
					new_household_object.name = arg_absent_parent_object.last_name
					new_household_object.save!

					# add hh member and make him 'in household'
					new_hh_member = HouseholdMember.set_household_member_data(new_household_object.id,arg_absent_parent_object.id)
					new_hh_member.save!

					HouseholdMemberStepStatus.populate_all_steps_for_client(arg_absent_parent_object.id)
			  		# 2. update first step as completed.
			  		HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(arg_absent_parent_object.id,'household_member_demographics_step','Y')
			  		HouseholdMemberStepStatus.update_household_id_to_client_steps(arg_absent_parent_object.id,new_household_object.id)
			  		# 3. update address step as completed.

		  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(arg_absent_parent_object.id,'household_member_address_step','Y')

				end

        	end # end of  ActiveRecord::Base.transaction do
            ls_msg = "SUCCESS"
        rescue => err
            	error_object = CommonUtil.write_to_attop_error_log_table("ParentalResponsibility-Model","create_client_parental_responsibility",err,AuditModule.get_current_user.uid)
            	ls_msg = "Failed to save parental responsibility - for more details refer to error ID: #{error_object.id}."
        end # end of begin
        return ls_msg
    end




end