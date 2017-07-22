class Alert < ActiveRecord::Base
has_paper_trail :class_name => 'AlertVersion',:on => [:update, :destroy]
	    include AuditModule
	 before_create :set_create_user_fields
     before_update :set_update_user_field


    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    HUMANIZED_ATTRIBUTES = {
        alert_text: "Alert Text",
        expiration_date: " Expiration Date",
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


     validate :general_alert_validation


     def self.set_alert(arg_alert_category,
                        arg_alert_type,
                        arg_alert_for_type,
                        arg_alert_for_id,
                        arg_alert_text,
                        arg_status,
                        arg_alert_assigned_to_user_id)

         alert_collection = Alert.where("alert_category = ?
                                        and alert_type = ?
                                        and alert_for_type = ?
                                        and alert_for_id = ?
                                        and alert_text = ?
                                        and status = 6339",arg_alert_category,
                                                          arg_alert_type,
                                                          arg_alert_for_type,
                                                          arg_alert_for_id,
                                                          arg_alert_text
                                    )
          if alert_collection.present?
          # There is already pending alert exists
            return_object = alert_collection.first
            return_object.alert_assigned_to_user_id = arg_alert_assigned_to_user_id
            return_object.information_only = 'Y'
          else
            alert_object = Alert.new
            ls_alert_text = CommonUtil.valid_string_of_length_255(arg_alert_text)
            alert_object.alert_text = ls_alert_text
            alert_object.alert_category = arg_alert_category
            alert_object.alert_type = arg_alert_type
            alert_object.alert_for_type = arg_alert_for_type
            alert_object.alert_for_id = arg_alert_for_id
            alert_object.alert_assigned_to_user_id = arg_alert_assigned_to_user_id
            alert_object.status = arg_status
            alert_object.information_only = 'Y'
            return_object = alert_object
          end
          return return_object


     end




 #   	def self.check_work_alert_found?(arg_alert_category,
	# 	                             arg_alert_type,
	# 	                             arg_alert_for_type,
	# 	                             arg_alert_for_id
	# 	                             )
 #  		alert_collection = Alert.where("alert_category = ?
 #  			  and alert_type = ?
 #  			  and alert_for_type = ?
 #  			  and alert_for_id = ?
 #  			  ",arg_alert_category,
 #  			   arg_alert_type,
 #  			   arg_alert_for_type,
 #  			   arg_alert_for_id)
 #  		if alert_collection.present?
 #  			return true
 #  		else
 #  			return false
 #  		end
	# end

  # def self.delete_alerts_associated_with_completed_work_tasks(arg_user_id)
  #   completed_work_task_collection_for_logged_in_user = WorkTask.where("assigned_to_type = 6342
  #                                                                      and complete_date is not null
  #                                                                      and assigned_to_id = ?",arg_user_id)
  #   if completed_work_task_collection_for_logged_in_user.present?
  #       completed_work_task_collection_for_logged_in_user.each do |each_task|
  #         aler_for_this_task_collection = Alert.where("alert_category = 6348
  #                                                     and alert_type = ?
  #                                                     and alert_for_type = ?
  #                                                     and alert_for_id = ?",each_task.task_type,
  #                                                                           each_task.beneficiary_type,
  #                                                                            each_task.reference_id
  #                                                     )
  #         if aler_for_this_task_collection.present?
  #           alert_object = aler_for_this_task_collection.first
  #           alert_object.destroy
  #         end
  #       end
  #   end
  # end

	# def self.get_business_alerts_for_user(arg_user_id)
	# 	Alert.where("alert_assigned_to_user_id = ?
	# 		         and status = 6339
	# 		         and alert_category = 6348
	# 		         and (information_only != 'Y' OR information_only is null)
	# 		         ",arg_user_id)
	# end


	def self.get_general_information_alerts()
		ldt_today = Date.today
		Alert.where("alert_category = 6347 and expiration_date >= ?",ldt_today).order("expiration_date ASC")
	end


   def self.get_general_information_expired()
		ldt_today = Date.today
		Alert.where("alert_category = 6347 and expiration_date < ?",ldt_today)
	end


	def general_alert_validation

        if alert_category == 6347
          validates_presence_of :alert_text, message: "is required"
          validates_presence_of :expiration_date, message: "is required"
          DateService.valid_future_date?(self,expiration_date,"Expiration Date")

        end

    end
    def self.get_business_alerts_for_user_information_only(arg_user_id)
        step1 = Alert.joins("INNER JOIN codetable_items
                            on (alerts.alert_type = codetable_items.id
                            and codetable_items.code_table_id = 18)")
        step2 = step1.where("alert_assigned_to_user_id = ? and status = 6339 and alert_category = 6348 and information_only = 'Y'",arg_user_id)
        step3 = step2.select("alerts.*").order("id DESC")
        alert = step3
        return alert
    # Alert.where("alert_assigned_to_user_id = ? and status = 6339 and alert_category = 6348 and information_only = 'Y'",arg_user_id).order("id DESC")
    end

	def self.create_information_only_work_alerts(arg_alert_text,
												 arg_alert_category,
												 arg_alert_type,
												 arg_alert_for_type,
												 arg_alert_for_id,
												 arg_alert_assigned_to_user_id,
												 arg_status,
												 arg_information_only
												)
       ls_return = " "
      	alert_collection = Alert.where("alert_category = ?
                                  and alert_type = ?
                                  and alert_for_type = ?
                                  and alert_for_id = ?
                                  and alert_text = ?
                                  and status = 6339",arg_alert_category,
                                             arg_alert_type,
                                             arg_alert_for_type,
                                             arg_alert_for_id,
                                             arg_alert_text)
      if alert_collection.present?
         ls_return = "SUCCESS"
      	# There is already pending alert exists
      else
      	  alert_object = Alert.new
      	  alert_object.alert_text = arg_alert_text
          alert_object.alert_category = arg_alert_category
          alert_object.alert_type = arg_alert_type
          alert_object.alert_for_type = arg_alert_for_type
          alert_object.alert_for_id = arg_alert_for_id
          alert_object.alert_assigned_to_user_id = arg_alert_assigned_to_user_id
          alert_object.status = arg_status
          alert_object.information_only = arg_information_only
          if alert_object.save == true
            ls_return = "NEWRECORD"
          else
          	 ls_error_message = alert_object.errors.full_messages.last
          	 li_user_id = AuditModule.get_current_user.uid
          	CommonUtil.write_to_attop_error_log_table_without_trace_details("Alert Model","create_information_only_work_alerts","Error in create_information_only_work_alerts Method in Alert Model",ls_error_message,li_user_id)
             ls_return = "Failed to create work task, For more details refer to error ID: #{error_object.id}."
          end
      end
      Rails.logger.debug("ls_return = #{ls_return.inspect}")
    return ls_return
	end


  #  def self.create_information_only_alert_for_client_information_change(arg_client_id,arg_alert_text)
  #   # logger.debug("MNP2 - create_task_for_client_information_change - arg_client_id = #{arg_client_id} AND arg_instructions = #{arg_instructions}")
  #    # Rule1: Is this client present in an open program unit.
  #    if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id) == true
  #       open_program_unit_object = ProgramUnit.get_open_client_program_units(arg_client_id).first
  #        # Rule2:Find the case manager for the open program unit.
  #        li_case_manager_id = open_program_unit_object.case_manager_id

  #        # Rule4 : create work task
  #        Alert.create_information_only_work_alerts(arg_alert_text,#arg_alert_text,
		# 										 6348,#arg_alert_category, = Business Alert
		# 										 2173, #arg_alert_type, = information change
		# 										 6172, #arg_alert_for_type, = participant
		# 										 arg_client_id,#arg_alert_for_id,
		# 										 li_case_manager_id, #arg_alert_assigned_to_user_id,
		# 										 6339,#arg_status,
		# 										 'Y' #arg_information_only
		# 							         	)


  #    end
  # end

end
