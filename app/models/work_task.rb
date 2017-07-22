class WorkTask < ActiveRecord::Base
  has_paper_trail :class_name => 'WorkTaskVersion',:on => [:update, :destroy]

   include AuditModule
	 before_create :set_create_user_fields, :set_auto_complete_by_system_flag
   before_update :set_update_user_field


HUMANIZED_ATTRIBUTES = {
  assigned_to_id: "Assigned To"  ,
  household_id: "Household ID"  ,
  task_category: "Category" ,
  task_type: "Type" ,
  client_id: "Client ID" ,
  beneficiary_type: "Task For" ,
  reference_id: "Reference ID" ,
  due_date: "Due Date" ,
  complete_date: "Completion Date" ,
  action_text: "Task" ,
  instructions: "Instructions" ,
  urgency: "Urgency" ,
  notes: "Notes" ,
  status: "Status" ,
  created_by: "Assigned By" ,
  created_at: "Creation Date",
  auto_complete_by_system: "Completed By System"

    }

# 1.
  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates_presence_of :task_category,:task_type,:action_text,:assigned_to_id,:due_date,:instructions,:urgency,:status,message: "is required."
  validate :valid_due_date?
  validate :valid_complete_date?

# 2.
    def valid_due_date?
        DateService.valid_date?(self,due_date,"Due Date")
    end

# 3.
    def valid_complete_date?
        DateService.valid_date?(self,complete_date,"Completion Date")
    end

# 4.
    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

# 5.
    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def set_auto_complete_by_system_flag
      system_params_value = SystemParam.get_key_list(9,task_type)
      case system_params_value
       when "SYSTEM_CREATED_SYSTEM_CLOSE"
            self.auto_complete_by_system = 'Y'
       when "SYSTEM_CREATED_MANUAL_CLOSE"
            self.auto_complete_by_system = 'N'
       else
            self.auto_complete_by_system = 'N'
       end

    end

# 6.
    # def self.logged_in_user_tasks(arg_user_id)
    #   WorkTask.where("assigned_to_id = ?",arg_user_id).order(" (due_date - current_date) ASC")
    # end

# 7.


# 8.
  def self.case_manager_assignment_task_pending_for_this_program_unit?(arg_program_unit_id)
      work_task_collection = WorkTask.where("assigned_to_type = 6343 and task_type in (6344,2176) and status = 6339 and reference_id = ? ",arg_program_unit_id)
      if work_task_collection.present?
        lb_return = true
      else
        lb_return = false
      end
      return lb_return
  end

# 9.
  # def self.get_pending_local_office_tasks_given_local_office_id(arg_local_office_id)
  #    local_office_pending_task_collection = WorkTask.where("assigned_to_type = 6343 and status = 6339 and assigned_to_id = ?",arg_local_office_id)
  # end

# 10.
def self.get_pending_user_tasks(arg_user_id)
    step1 = WorkTask.joins("INNER JOIN codetable_items
                            on work_tasks.task_type = codetable_items.id
                            and codetable_items.code_table_id = 18")
    step2 = step1.where("(complete_date is null
                         and work_tasks.status in (6339,6340)
                         and assigned_to_id = ?)",arg_user_id)
    step3 = step2.select("work_tasks.*").order("updated_at DESC")
    user_pending_task_collection = step3
    return user_pending_task_collection
    # user_pending_task_collection = WorkTask.where("assigned_to_type = 6342 and complete_date is null and assigned_to_id = ?",arg_user_id).order("id DESC")
end


# 11.
  # def self.get_overdue_pending_task_for_user(arg_user_id)
  #   ldt_today = Date.today
  #   pending_task_for_today_collection = WorkTask.where("due_date <= ? and complete_date is null and assigned_to_type = 6342 and assigned_to_id = ?",ldt_today,arg_user_id).order("due_date desc")
  #   return pending_task_for_today_collection
  # end



# 12.
  # def self.get_work_task_for_alert(arg_alert_id)
  #   step1 = WorkTask.joins("INNER JOIN alerts
  #                         ON (alerts.alert_type = work_tasks.task_type
  #                            and alerts.alert_for_type = work_tasks.beneficiary_type
  #                            and alerts.alert_for_id = work_tasks.reference_id
  #                            and alerts.alert_assigned_to_user_id = work_tasks.assigned_to_id
  #                            and work_tasks.assigned_to_type = 6342
  #                            and alerts.alert_category = 6348
  #                            and work_tasks.complete_date is null
  #                           )
  #                         ")
  #   step2 = step1.where("alerts.id = ?",arg_alert_id)
  #   work_task_object = step2.first
  #   return work_task_object
  # end

# 13.
  def self.get_user_tasks(arg_user_id,arg_status)
    user_tasks_collection = WorkTask.where("assigned_to_type = 6342
                                           and status = ?
                                           and assigned_to_id = ?",arg_status,arg_user_id
                                          ).order("id DESC")
  end

# 14.
  def self.get_local_office_tasks(arg_local_office_id,arg_status)
     # local_office_task_collection = WorkTask.where("assigned_to_type = 6343
     #                                                and status = ?
     #                                                and assigned_to_id = ?",arg_status,arg_local_office_id)
     step1 = WorkTask.joins("INNER JOIN user_local_offices
                            ON work_tasks.assigned_to_id = user_local_offices.user_id")
     step2 = step1.where("work_tasks.status = ?
                         and user_local_offices.local_office_id = ?",arg_status,arg_local_office_id).order("id DESC")
     local_office_task_collection = step2
     return local_office_task_collection

  end

# 15.
  def self.get_completed_user_tasks(arg_user_id)
    step1 = WorkTask.joins("INNER JOIN codetable_items
                            on work_tasks.task_type = codetable_items.id
                            and codetable_items.code_table_id = 18")
    step2 = step1.where("work_tasks.status = 6341
                         and complete_date is not null
                         and assigned_to_id = ?",arg_user_id)
    step3 = step2.select("work_tasks.*").order("updated_at DESC")
    user_completed_task_collection = step3
    return user_completed_task_collection
      # user_completed_task_collection = WorkTask.where("assigned_to_type = 6342 and complete_date is not null and assigned_to_id = ?",arg_user_id).order("updated_at DESC")
  end


# 16.
  #  def self.create_work_on_sanction_task_to_compliance_officer(arg_sanction_id)
  #   # Manoj Patil 05/14/2015
  #   # Description : create 'Work on Sanction' task to Local office.
  #   # WORK TASK TYPE :2168 : "Sanction"
  #   msg = " "
  #   sanction_object = Sanction.find(arg_sanction_id)

  #         work_task_collection = WorkTask.where("task_type = ? and reference_id = ?",2168,sanction_object.id)
  #         if work_task_collection.present?
  #            work_task_object = work_task_collection.first
  #         else
  #            work_task_object = WorkTask.new
  #         end

  #         work_task_object.assigned_to_type = 6343 # Local office
  #         # get the Local office of the casemanager/ worker who created Infraction start date
  #         li_user_id = sanction_object.updated_by
  #         user_object = User.find(li_user_id)
  #         work_task_object.assigned_to_id = user_object.location #  Local office ID

  #         work_task_object.assigned_by_user_id = AuditModule.get_current_user.uid
  #         ls_local_office = CodetableItem.get_short_description (user_object.location)
  #          # client ID
  #         work_task_object.client_id =sanction_object.client_id
  #         client_object = Client.find(sanction_object.client_id)
  #         ls_client_name =client_object.get_client_name

  #         #  work_task_object.instructions
  #         ls_instructions = "This is a system created task for compliance officer to work on the sanction for client:#{ls_client_name}(#{client_object.id}).This task is assigned to local office: #{ls_local_office}."
  #         work_task_object.instructions = ls_instructions
  #         work_task_object.task_category = 6366 # Client


  #         #task_type
  #         work_task_object.task_type = 2168 # "Sanction"
  #         # action_text (task)
  #         work_task_object.action_text = "Work on sanction task."
  #         # beneficiary_type
  #         work_task_object.beneficiary_type = 6367 # Sanction
  #         # reference_id
  #         work_task_object.reference_id = sanction_object.id # sanction ID
  #         # due_date
  #         # Get number of days to complete from system param table
  #         l_days_to_complete_task = SystemParam.get_key_value(18,"6367","Number of days to complete Task - 'Work on Sanction Task-Days to complete = 10'")
  #         l_days_to_complete_task = l_days_to_complete_task.to_i
  #         ldt_due_date = Date.today + l_days_to_complete_task
  #         work_task_object.due_date = ldt_due_date

  #         #urgency
  #         work_task_object.urgency = 2188 # High
  #         # status
  #         work_task_object.status = 6339 # Pending

  #        # logger.debug("work_task_object = #{work_task_object.inspect}")
  #         # logger.debug("work_task_object = #{work_task_object.inspect}")
  #         if work_task_object.save
  #           msg = "SUCCESS"
  #         else
  #           #                         write_to_attop_error_log_table_without_trace_details(arg_object_name, arg_method_name,                                    arg_error_message,                         arg_additional_error_details_message,                       arg_logged_in_user)
  #           error_object = CommonUtil.write_to_attop_error_log_table_without_trace_details("WorkTask Model","create_work_on_sanction_task_to_compliance_officer",work_task_object.errors.full_messages.last,'Failed to create Sanction work task to compliance officer',AuditModule.get_current_user.uid)
  #           msg = "Error ID: #{error_object.id} - Error when creating work task."
  #         end


  #   return msg
  # end

# 17.
  # def self.complete_work_on_sanction_task_to_compliance_officer_from_sanction(arg_sanction_id)
  #   # Manoj Patil 05/15/2015
  #   #Description:
  #   # 1. Mark the Pending Task as Complete
  #   # 2. create an alert (work-information only) to case manager - informing Compliance officer took action.
  #   sanction_object = Sanction.find(arg_sanction_id)
  #   msg = "SUCCESS"
  #   if sanction_object.infraction_end_date.present?
  #     work_task_collection = WorkTask.where("assigned_to_type = 6343 and task_type = 2168 and reference_id = ? ",arg_sanction_id)
  #     if work_task_collection.present?
  #         work_task_object = work_task_collection.first
  #         work_task_object.status = 6341 # complete
  #         work_task_object.complete_date = Date.today
  #         # Create a new alert to case worker who assigned this task to compliance officer
  #        alert_object_collection = Alert.where("alert_type = 6348 and alert_for_type = 2168 and alert_for_id = ?",arg_sanction_id)
  #        if alert_object_collection.present?
  #           alert_object = alert_object_collection.first
  #        else
  #           alert_object = Alert.new
  #        end
  #         client_object = Client.find(sanction_object.client_id)
  #         alert_text = "Compliance officer worked on sanction for client:#{client_object.get_client_name} and he terminated the sanction by entering infraction end date."
  #         alert_object.alert_text = alert_text
  #         alert_object.alert_category = 6348 # Business Alert
  #         alert_object.alert_type = work_task_object.task_type
  #         alert_object.alert_for_type = work_task_object.beneficiary_type
  #         alert_object.alert_for_id = work_task_object.reference_id
  #         alert_object.alert_assigned_to_user_id = work_task_object.assigned_by_user_id
  #         alert_object.status = 6339 # pending
  #         alert_object.information_only = 'Y'
  #         begin
  #             ActiveRecord::Base.transaction do
  #               work_task_object.save!
  #               alert_object.save!
  #             end
  #             msg = "SUCCESS"
  #           rescue => err
  #               error_object = CommonUtil.write_to_attop_error_log_table("WorkTask-Model","complete_work_on_sanction_task_to_compliance_officer task",err,AuditModule.get_current_user.uid)
  #               msg = "Failed to complete work on sanction task - for more details refer to error ID: #{error_object.id}."
  #         end

  #     end
  #   end
  #     return msg
  # end


# 18.
  # def self.complete_work_on_sanction_task_to_compliance_officer_from_sanction_detail(arg_sanction_detail_id)
  #   # Manoj Patil 05/15/2015
  #   #Description:
  #   # 1. Mark the Pending Task as Complete
  #   # 2. create an alert (work-information only) to case manager - informing Compliance officer took action.
  #   sanction_detail_object = SanctionDetail.find(arg_sanction_detail_id)
  #   sanction_object = Sanction.find(sanction_detail_object.sanction_id)

  #   msg = "SUCCESS"
  #     work_task_collection = WorkTask.where("assigned_to_type = 6343 and task_type = 2168 and status !=6341 and reference_id = ? ",sanction_object.id)
  #     if work_task_collection.present?
  #         work_task_object = work_task_collection.first
  #         work_task_object.status = 6341 # complete
  #         work_task_object.complete_date = Date.today
  #         # Create a new alert to case worker who assigned this task to compliance officer
  #        alert_object_collection = Alert.where("alert_type = 6348 and alert_for_type = 2168 and alert_for_id = ?",sanction_object.id)
  #        if alert_object_collection.present?
  #           alert_object = alert_object_collection.first
  #        else
  #           alert_object = Alert.new
  #        end

  #         client_object = Client.find(sanction_object.client_id)
  #         sanction_month = sanction_detail_object.sanction_month
  #         ls_sanction_month = sanction_month.strftime("%Y-%m")
  #         alert_text = "Compliance officer worked on sanction for client:#{client_object.get_client_name} and applied sanction for month:#{ls_sanction_month}."
  #         alert_object.alert_text = alert_text
  #         alert_object.alert_category = 6348 # Business Alert
  #         alert_object.alert_type = work_task_object.task_type
  #         alert_object.alert_for_type = work_task_object.beneficiary_type
  #         alert_object.alert_for_id = work_task_object.reference_id
  #         alert_object.alert_assigned_to_user_id = work_task_object.assigned_by_user_id
  #         alert_object.status = 6339 # pending
  #         alert_object.information_only = 'Y'

  #         begin
  #             ActiveRecord::Base.transaction do
  #               work_task_object.save!
  #               alert_object.save!
  #             end
  #             msg = "SUCCESS"
  #           rescue => err
  #               error_object = CommonUtil.write_to_attop_error_log_table("WorkTask-Model","complete_work_on_sanction_task_to_compliance_officer task",err,AuditModule.get_current_user.uid)
  #               msg = "Failed to complete work on sanction task - for more details refer to error ID: #{error_object.id}."
  #         end

  #     end

  #     return msg
  # end


# 19.


# 20.
  # def self.delete_any_pending_sanction_tasks(arg_sanction_id)
  #   WorkTask.where("status = 6339 and task_type = 2168 and beneficiary_type = 6367 and reference_id = ?",arg_sanction_id).destroy_all
  #   Alert.where("status = 6339 and alert_type = 6348  and alert_for_type = 6367 and alert_type = 2168 and alert_for_id = ?",arg_sanction_id).destroy_all
  # end



# 21.

 def self.save_work_task(arg_task_type,
                          arg_beneficiary_type,
                          arg_reference_id,
                          arg_action_text,
                          arg_assigned_to_type,
                          arg_assigned_to_id,
                          arg_assigned_by_user_id,
                          arg_task_category,
                          arg_client_id,
                          arg_due_date,
                          arg_instructions,
                          arg_urgency,
                          arg_notes,
                          arg_status,
                          arg_program_unit_id)

      # Manoj Patil
      # 05/27/2015.
      # Common Method to create/update work task

      #  find unique work task record.

      # logger.debug("MNP3 - in -save_work_task ")
      ls_return = " "
      work_task_collection = WorkTask.where("task_type = ?
                                            and beneficiary_type = ?
                                            and reference_id = ?
                                            and action_text = ?
                                            and status = 6339",arg_task_type,
                                             arg_beneficiary_type,
                                             arg_reference_id,
                                             arg_action_text)
      if work_task_collection.present?
         ls_return = "SUCCESS"
        #  pending work task already exists - no need to create one more
      else
        new_work_task_object = WorkTask.new
        new_work_task_object.assigned_to_type = arg_assigned_to_type
        new_work_task_object.assigned_to_id = arg_assigned_to_id
        new_work_task_object.assigned_by_user_id = arg_assigned_by_user_id
        new_work_task_object.task_category = arg_task_category
        new_work_task_object.task_type = arg_task_type
        new_work_task_object.client_id = arg_client_id
        new_work_task_object.beneficiary_type = arg_beneficiary_type
        new_work_task_object.reference_id = arg_reference_id
        new_work_task_object.due_date = arg_due_date
        new_work_task_object.action_text = arg_action_text
        new_work_task_object.instructions = arg_instructions
        new_work_task_object.urgency = arg_urgency
        new_work_task_object.notes = arg_notes
        new_work_task_object.status = arg_status
        new_work_task_object.program_unit_id = arg_program_unit_id
        if new_work_task_object.save == true
          ls_return = "NEWRECORD"
           # logger.debug("MNP4 - save success ")
        else
           # logger.debug("MNP5 - save failed ")
         # CommonUtil.write_to_attop_error_log_table_without_trace_details(arg_object_name,arg_method_name,arg_error_message,arg_additional_error_details_message,arg_logged_in_user)
          ls_error_message = new_work_task_object.errors.full_messages.last
          error_object = CommonUtil.write_to_attop_error_log_table_without_trace_details("WorkTask Model","save_work_task","Error in save_work_task ethod in WorkTask Model",ls_error_message,arg_assigned_by_user_id)
          ls_return = "Failed to create work task, for more details refer to error ID: #{error_object.id}."
        end


      end
      return ls_return
  end



# 24.
  def self.set_work_task(arg_task_type,
                          arg_beneficiary_type,
                          arg_reference_id,
                          arg_action_text,
                          arg_assigned_to_type,
                          arg_assigned_to_id,
                          arg_assigned_by_user_id,
                          arg_task_category,
                          arg_client_id,
                          arg_due_date,
                          arg_instructions,
                          arg_urgency,
                          arg_notes,
                          arg_status)

      # Manoj Patil
      # 05/27/2015.
      # Common Method to set work task
      work_task_collection = WorkTask.where("task_type = ?
                                            and beneficiary_type = ?
                                            and reference_id = ?
                                            and status = 6339",arg_task_type,
                                             arg_beneficiary_type,
                                             arg_reference_id)
      if work_task_collection.present?
        #  pending work task already exists - return
        work_task_object = work_task_collection.first
        work_task_object.action_text = arg_action_text
        work_task_object.instructions = arg_instructions
        work_task_object.assigned_to_type = arg_assigned_to_type
        work_task_object.assigned_to_id = arg_assigned_to_id
        work_task_object.assigned_by_user_id = arg_assigned_by_user_id
        work_task_object.task_category = arg_task_category
        work_task_object.client_id = arg_client_id
        work_task_object.due_date = arg_due_date
        work_task_object.urgency = arg_urgency
        work_task_object.notes = arg_notes
      else
        work_task_object = WorkTask.new
        work_task_object.assigned_to_type = arg_assigned_to_type
        work_task_object.assigned_to_id = arg_assigned_to_id
        work_task_object.assigned_by_user_id = arg_assigned_by_user_id
        work_task_object.task_category = arg_task_category
        work_task_object.task_type = arg_task_type
        work_task_object.client_id = arg_client_id
        work_task_object.beneficiary_type = arg_beneficiary_type
        work_task_object.reference_id = arg_reference_id
        work_task_object.due_date = arg_due_date
        work_task_object.action_text = arg_action_text
        work_task_object.instructions = arg_instructions
        work_task_object.urgency = arg_urgency
        work_task_object.notes = arg_notes
        work_task_object.status = arg_status
      end
      return work_task_object
  end


# 25.
    # def self.common_complete_work_task(arg_task_type,arg_beneficiary_type,arg_reference_id)
    #     work_task_collection = WorkTask.where("task_type = ?
    #                                            and beneficiary_type = ?
    #                                            and reference_id = ?
    #                                            and status = 6339",
    #                                            arg_task_type,
    #                                            arg_beneficiary_type,
    #                                            arg_reference_id
    #                                            )
    #     if work_task_collection.present?
    #       work_task_object = work_task_collection.first
    #       work_task_object.complete_date = Date.today
    #       work_task_object.status = 6341 # complete
    #       work_task_object.save
    #     end

    #     # Find if any alerts agains the program unit ID for same alert type
    #     alert_collection = Alert.where("alert_type = ?
    #                                     and alert_for_type = ?
    #                                     and alert_for_id = ?
    #                                      ",arg_task_type,
    #                                      arg_beneficiary_type,
    #                                      arg_reference_id
    #                                      )
    #     if alert_collection.present?
    #       alert_object = alert_collection.first
    #       alert_object.status = 6341 # complete
    #       alert_object.save
    #     end
    # end




# 28.
  # def self.get_work_task_for_client_and_task_type(arg_program_unit_id)
  #     WorkTask.where("reference_id = ? and task_type = 2176",arg_program_unit_id).last
  # end


# 29.
  def self.eligibility_worker_assignment_task_pending_for_this_program_unit?(arg_program_unit_id)
      work_task_collection = WorkTask.where("assigned_to_type = 6343 and task_type =6386 and status = 6339 and reference_id = ? ",arg_program_unit_id)
      if work_task_collection.present?
        lb_return = true
      else
        lb_return = false
      end
      return lb_return
  end

  #30.

  def self.transfer_task_to_other_user(arg_assigned_to_user_id,arg_task_type,arg_reference_id)
    #  This method should be called in a controller with TRANSACTION BLOCK
      work_task_collection = WorkTask.where("task_type = ? and reference_id = ? and status = 6339",arg_task_type,arg_reference_id)
      if work_task_collection.present?
        work_task_collection.each do |each_task|
          each_task.assigned_to_id = arg_assigned_to_user_id
          each_task.assigned_by_user_id = AuditModule.get_current_user.uid
          each_task.save!
        end
      end

  end

  #31
  def self.transfer_pending_tasks_from_one_user_to_another(arg_reference_type,arg_reference_id,arg_current_worker_id,arg_new_worker_id)
    # called in active transaction block - if save! fails should be handled in rescue of calling transaction
    pending_tasks_collection = WorkTask.where("assigned_to_id = ?
                                               and status = 6339
                                               and beneficiary_type = ?
                                               and reference_id = ?",
                                               arg_current_worker_id,
                                               arg_reference_type,
                                               arg_reference_id)
    if pending_tasks_collection.present?
      pending_tasks_collection.each do |each_pending_task|
        each_pending_task.assigned_to_id = arg_new_worker_id
        each_pending_task.save!
      end
    end

  end

   def self.transfer_pending_tasks_from_one_user_to_another_for_program_unit(arg_program_unit_id,arg_current_worker_id,arg_new_worker_id)
    # called in active transaction block - if save! fails should be handled in rescue of calling transaction
    pending_tasks_collection = WorkTask.where("assigned_to_id = ?
                                               and status = 6339
                                               and program_unit_id = ?",
                                               arg_current_worker_id,
                                               arg_program_unit_id)
    if pending_tasks_collection.present?
      pending_tasks_collection.each do |each_pending_task|
        each_pending_task.assigned_to_id = arg_new_worker_id
        each_pending_task.save!
      end
    end

  end

  def self.work_task_created_by(task_type)
    work_task = SystemParam.get_key_list(9,task_type)
         case work_task
         when "SYSTEM_CREATED_SYSTEM_CLOSE"
              result = 'system_closed'
         when "SYSTEM_CREATED_MANUAL_CLOSE"
              result = 'manual_closed'
         else
              result = 'manual_create'
         end
    return result
  end

  def self.delete_any_pending_work_tasks(arg_program_unit_id, arg_task_type)
    work_tasks = where("program_unit_id = ? and task_type = ? and status = 6339",arg_program_unit_id, arg_task_type)
    work_tasks.destroy_all if work_tasks.present?
  end

  def self.delete_all_pending_work_tasks(arg_program_unit_id)
    work_tasks = where("program_unit_id = ? and status = 6339",arg_program_unit_id)
    work_tasks.destroy_all if work_tasks.present?
  end

end






