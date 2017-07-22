class ClientCharacteristicService
	def self.create_client_characteristics(arg_client_characteristic_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
                msg = trigger_events_for_characteristic_attr_changes(arg_client_characteristic_object, arg_client_id)
            	notes_type = get_notes_type_from_charateristic_type(arg_client_characteristic_object.characteristic_type)
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        notes_type,  # notes_type = Characteristics
	                                        arg_client_characteristic_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,notes_type,arg_client_characteristic_object.id)
		        end
            end
            return arg_client_characteristic_object
    	rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristic-Model","create_client_characteristics",err,AuditModule.get_current_user.uid)
            msg = "Failed to update client characteristic- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.delete_client_characteristics(arg_client_characteristic_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
                notes_type = get_notes_type_from_charateristic_type(arg_client_characteristic_object.characteristic_type)
            	arg_client_characteristic_object.destroy!
	            if arg_notes.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_id,notes_type,arg_client_characteristic_object.id)
	            end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristic-Model","delete_client_characteristics",err,AuditModule.get_current_user.uid)
	            msg = "Failed to delete client characteristic- for more details refer to error ID: #{error_object.id}."
        end
	end

    def self.get_notes_type_from_charateristic_type(arg_characteristic_type)
        notes_type = nil
        case arg_characteristic_type
        when "WorkCharacteristic"
            notes_type = 6478
        when "DisabilityCharacteristic"
            notes_type = 6476
        when "SubstanceAbuseCharacteristic"
            notes_type = 6477
        when "OtherCharacteristic"
            notes_type = 6480
        when "LegalCharacteristic"
            notes_type = 6479
        when "MentalCharacteristic"
            notes_type = 5757
        when "DomesticViolenceCharacteristic"
            notes_type = 5754
        end
        return notes_type
    end

    def self.trigger_events_for_characteristic_attr_changes(arg_client_characteristic_object, arg_client_id)
        ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
            common_action_argument_object = CommonEventManagementArgumentsStruct.new
            common_action_argument_object.client_id = arg_client_id
            common_action_argument_object.model_object = arg_client_characteristic_object
            common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
            common_action_argument_object.changed_attributes = arg_client_characteristic_object.changed_attributes().keys
            common_action_argument_object.is_a_new_record = arg_client_characteristic_object.new_record?
            common_action_argument_object.run_month = arg_client_characteristic_object.start_date
            arg_client_characteristic_object.save!
            ls_msg = EventManagementService.process_event(common_action_argument_object)
        else
           arg_client_characteristic_object.save!
        end
        return ls_msg
    end

    def self.is_the_client_deferred(arg_client_id, arg_start_date, arg_end_date)
        result = false
        start_date = end_date = nil
        if ClientCharacteristic.has_a_deferred_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
            result = true
        else
            deferred_characterisctics = ClientCharacteristic.get_deferred_characteristic_records(arg_client_id, arg_end_date)
            # Rails.logger.debug("deferred_characterisctics = #{deferred_characterisctics.inspect}")
            # fail

            # deferred_characterisctics.each do |characteristic|
            #     start_date = characteristic.start_date if start_date.blank?
            #     end_date = characteristic.end_date if end_date.blank?
            #     if end_date.present?
            #         if (characteristic.start_date < end_date) || (characteristic.start_date - 1 == end_date)
            #             if characteristic.end_date.blank?
            #                 result = true
            #                 break
            #             else
            #                 end_date = characteristic.end_date
            #                 result = true if end_date == arg_end_date # This check ensures that he has defferred characteristics for the entire reporting month range
            #             end
            #         else
            #             result = false
            #         end
            #     end
            #     # Rails.logger.debug("result = #{result}")
            #     # Rails.logger.debug("start_date = #{start_date}")
            #     # Rails.logger.debug("end_date = #{end_date}")
            # end
            result = is_the_characteristic_present_for_the_entire_date_range(deferred_characterisctics, arg_start_date, arg_end_date)
        end
        # Rails.logger.debug("result =  #{result}")
        # fail
        # Rails.logger.debug("start_date = #{start_date}")
        # Rails.logger.debug("arg_start_date = #{arg_start_date}")
        # Rails.logger.debug("end_date = #{end_date}")
        # Rails.logger.debug("arg_end_date = #{arg_end_date}")
        # fail
        result = false unless (result || (start_date.present? && end_date.present? && start_date <= arg_start_date && end_date >= arg_end_date))
        # Rails.logger.debug("result =  #{result}")
        # fail
        return result
    end

    def self.is_the_client_disabled(arg_client_id, arg_start_date, arg_end_date)
        result = false
        start_date = end_date = nil
        if ClientCharacteristic.has_a_disabled_work_characteristic_in_a_given_date_range(arg_client_id, arg_start_date, arg_end_date)
            result = true
        else
            disabled_characterisctics = ClientCharacteristic.get_disabled_work_characteristic_records(arg_client_id, arg_end_date)

            # disabled_characterisctics.each do |characteristic|
            #     start_date = characteristic.start_date if start_date.blank?
            #     end_date = characteristic.end_date if end_date.blank?
            #     if end_date.present?
            #         if (characteristic.start_date < end_date) || (characteristic.start_date - 1 == end_date)
            #             if characteristic.end_date.blank?
            #                 result = true
            #                 break
            #             else
            #                 end_date = characteristic.end_date
            #                 result = true if end_date == arg_end_date # This check ensures that he has defferred characteristics for the entire reporting month range
            #             end
            #         else
            #             result = false
            #         end
            #     end
            # end
            result = is_the_characteristic_present_for_the_entire_date_range(disabled_characterisctics, arg_start_date, arg_end_date)
        end
        result = false unless (result || (start_date.present? && end_date.present? && start_date <= arg_start_date && end_date >= arg_end_date))
        return result
    end

    def self.determine_participation_status_for_the_parents_in_the_program_unit(arg_program_unit_id, arg_start_date, arg_end_date)
        mandatory = disabled = deferred = 0
        parent_participations = nil
        pgu_members = ProgramUnitService.get_parent_list_for_the_program_unit(arg_program_unit_id)
        if pgu_members.present?
            parent_participations = {}
            pgu_members.each do |pgm|
                if ClientCharacteristic.has_mandatory_work_characteristic_in_a_given_date_range(pgm.client_id, arg_start_date, arg_end_date)
                    mandatory += 1
                elsif ClientCharacteristicService.is_the_client_disabled(pgm.client_id, arg_start_date, arg_end_date)
                    disabled += 1
                elsif ClientCharacteristicService.is_the_client_deferred(pgm.client_id, arg_start_date, arg_end_date)
                    deferred += 1
                else
                    mandatory += 1
                end
            end
            parent_participations[:mandatory] = mandatory
            parent_participations[:disabled] = disabled
            parent_participations[:deferred] = deferred
        end
        return parent_participations
    end

    def self.is_the_characteristic_present_for_the_entire_date_range(arg_characteristics, arg_start_date, arg_end_date)
        result = false
        start_date = end_date = nil
        arg_characteristics.each do |characteristic|
            start_date = characteristic.start_date if start_date.blank?
            end_date = characteristic.end_date if end_date.blank?
            if end_date.present?
                if (characteristic.start_date < end_date) || (characteristic.start_date - 1 == end_date)
                    if characteristic.end_date.blank?
                        result = true
                        break
                    else
                        end_date = characteristic.end_date
                        result = true if end_date == arg_end_date # This check ensures that he has characteristics for the entire reporting month range
                    end
                else
                    result = false
                end
            end
        end
        return result
    end
end