class ProgramUnitParticipation < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramUnitPartcpatnVersion',:on => [:update, :destroy]

    include
    before_create :set_create_user_fields
    before_update :set_update_user_field

    belongs_to :program_unit
    validates :participation_status,:status_date,  presence: true

     # Manoj Patil 05/27/2015
    after_save :ed_warning_follow_up_tasks


    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id

    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_participation_status(arg_program_unit_id)
    	where("program_unit_id = ?", arg_program_unit_id).order(id: :desc)
    end

    def self.is_program_unit_participation_status_closed(arg_program_unit_id)
      participation_statuses = where("program_unit_id = ?", arg_program_unit_id).order(id: :desc)
      if participation_statuses.present? && participation_statuses.first.participation_status == 6044
        return true
      else
        return false
      end
    end

      def self.is_program_unit_participation_status_open(arg_program_unit_id)
      lb_return = false
      participation_status_collection = where("program_unit_id = ?", arg_program_unit_id).order(id: :desc)
      if participation_status_collection.present?
        participation_status_object = participation_status_collection.first
        if participation_status_object.participation_status == 6043
          lb_return = true
        end
      end
      return lb_return
    end

    def self.is_program_unit_participation_exists?(arg_program_unit_id)
      participation_statuses = where("program_unit_id = ?", arg_program_unit_id)
      if participation_statuses.present?
        return true
      else
        return false
      end
    end

  def self.get_application_opened_or_closed
   step1 = joins("INNER JOIN program_units ON program_units.id = program_unit_participations.program_unit_id and (PROGRAM_UNITS.SERVICE_PROGRAM_ID = 1 or PROGRAM_UNITS.SERVICE_PROGRAM_ID = 4)
                  INNER JOIN PROGRAM_UNIT_MEMBERS  ON (PROGRAM_UNIT_MEMBERS.PROGRAM_UNIT_ID = PROGRAM_UNITS.ID AND  PROGRAM_UNIT_MEMBERS.PRIMARY_BENEFICIARY = 'Y')
                  INNER JOIN CLIENTS ON (PROGRAM_UNIT_MEMBERS.CLIENT_ID = CLIENTS.ID)
                  INNER JOIN USERS ON  (USERS.UID= PROGRAM_UNITS.UPDATED_BY)
                  INNER JOIN CODETABLE_ITEMS AS LOCATIONS ON ( LOCATIONS.ID = PROGRAM_UNITS.PROCESSING_LOCATION)
                  INNER JOIN LOCAL_OFFICE_INFORMATIONS ON ( LOCAL_OFFICE_INFORMATIONS.CODE_TABLE_ITEM_ID = PROGRAM_UNITS.PROCESSING_LOCATION)
                  INNER JOIN ENTITY_ADDRESSES ON (ENTITY_ADDRESSES.ENTITY_ID = CLIENTS.ID AND ENTITY_ADDRESSES.ENTITY_TYPE = 6150)
                  INNER JOIN ADDRESSES ON (ADDRESSES.ID =  ENTITY_ADDRESSES.ADDRESS_ID AND ADDRESS_TYPE = 4665 AND EFFECTIVE_END_DATE IS NULL)
                  INNER JOIN NOTICE_TEXTS ON (PROGRAM_UNITS.SERVICE_PROGRAM_ID = NOTICE_TEXTS.SERVICE_PROGRAM_ID AND NOTICE_TEXTS.action_type = program_unit_participations.participation_status AND NOTICE_TEXTS.action_reason = program_unit_participations.reason)")
   step2 = step1.where(" (date(program_unit_participations.updated_at) = '2014-11-07' or date(program_unit_participations.created_at) = '2013-07-02')
                       and program_unit_participations.id = ( select max(ID) from program_unit_participations A where A.program_unit_id = program_unit_participations.program_unit_id)")

   step3 = step2.select(" program_units.id ,
                          PROGRAM_UNIT_MEMBERS.client_id as primary_member_CLIENT_ID,--program_unit_participations.updated_at,
                          PROGRAM_UNITS.SERVICE_PROGRAM_ID,
                          rtrim(ltrim(CLIENTS.first_name)) as first_name,
                          rtrim(ltrim(CLIENTS.last_name)) as last_name,
                          clients.id as member_client_id,
                          PROGRAM_UNIT_MEMBERS.PRIMARY_BENEFICIARY,
                          clients.ssn,
                          EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) as age,
                          clients.FIRST_NAME AS first,
                          clients.LAST_NAME  AS last,
                          clients.first_name as member_first_name,
                          clients.last_name  as member_last_name,
                          TO_CHAR(PROGRAM_UNIT_PARTICIPATIONS.STATUS_DATE,'MM/DD/YY') AS STATUS_DATE,
                          TO_CHAR(PROGRAM_UNIT_PARTICIPATIONS.ACTION_DATE,'MM/DD/YY') AS ACTION_DATE,
                          TO_CHAR(PROGRAM_UNIT_PARTICIPATIONS.ACTION_DATE + 30 ,'MM/DD/YY') AS date,
                          program_unit_participations.participation_status as status,
                          program_unit_participations.reason  ,
                          program_units.processing_location,
                          LOCATIONS.short_description as location_name,
                          local_office_informations.street_address1 AS mailing_address1,
                          local_office_informations.street_address2 AS mailing_address2,
                          local_office_informations.street_address_city as mailing_address_city,
                          local_office_informations.street_address_state as mailing_address_state,
                          local_office_informations.street_address_zip as mailing_address_zip,
                          local_office_informations.street_address_zip_suffix as mailing_address_zip_suffix,
                          program_units.updated_by,
                          program_units.updated_at,
                          users.phone_number,
                          ADDRESSES.address_line1 as address_line1,
                          ADDRESSES.address_line2 as address_line2,
                          ADDRESSES.city as city,
                          ADDRESSES.state as state,
                          ADDRESSES.zip as zip,
                          ADDRESSES.zip_suffix as suffix,
                          notice_texts.notice_text,
                          notice_texts.flag1 ,
                          notice_texts.flag2

                        ")
     application_opened_closed = step3

     return application_opened_closed
  end

    def self.set_participation_record(arg_program_unit_id,arg_action_date,arg_action_reason,arg_status)
      participation_object = ProgramUnitParticipation.new
      participation_object.program_unit_id = arg_program_unit_id
      participation_object.participation_status = arg_status #close
      participation_object.action_date = arg_action_date
      participation_object.status_date = Time.now.to_date
      participation_object.reason = arg_action_reason
      return participation_object
    end


    def self.is_the_client_present_in_open_program_unit?(arg_client_id)
        step1 = ProgramUnitParticipation.joins("INNER JOIN program_units
                                                ON program_unit_participations.program_unit_id = program_units.id
                                                INNER JOIN program_unit_members
                                                ON program_unit_members.program_unit_id = program_units.id
                                              ")
        step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
        step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
        step4 = step3.where("program_unit_participations.participation_status = 6043").count

        if step4 > 0
          return true
        else
          return false
        end
    end



    def ed_warning_follow_up_tasks
      # if status is Open
      if participation_status == 6043
        # Any ED warnings found?
        li_program_unit_id = program_unit_id
        pgu_warning_collection = ApplicationEligibilityResults.get_the_warning_results_list_based_on_program_unit_id(li_program_unit_id)
        if pgu_warning_collection.present?
          li_logged_in_user = AuditModule.get_current_user.uid

          # For all these warnings work task should be created and assigned to case manager.
          pgu_warning_collection.each do |each_warning_object|
            client_object = Client.find(each_warning_object.client_id)
            ls_warning = CodetableItem.get_short_description(each_warning_object.data_item_type)
            ls_action_text = "Program unit warning follow up task for client:#{client_object.get_full_name} for warning:#{ls_warning}."
            ls_intructions = "This is a system generated task to follow up on the program unit warnings for client:#{client_object.get_full_name} for warning:#{ls_warning}."
            l_days_to_complete_task = SystemParam.get_key_value(18,"2138","Number of days to complete Task - ED data changed- Days to complete = 7")
            l_days_to_complete_task = l_days_to_complete_task.to_i
            ldt_due_date = Date.today + l_days_to_complete_task

            program_unit_object = ProgramUnit.find(li_program_unit_id)
            li_case_manager_id = program_unit_object.case_manager_id
            WorkTask.save_work_task(2138,#arg_task_type,
                          each_warning_object.data_item_type,#arg_beneficiary_type,
                          each_warning_object.client_id,#arg_reference_id,
                          ls_action_text,#arg_action_text,
                          6342,#arg_assigned_to_type,
                          li_case_manager_id,#arg_assigned_to_id,
                          li_logged_in_user,#arg_assigned_by_user_id,
                          6366, #arg_task_category,
                          each_warning_object.client_id,#arg_client_id,
                          ldt_due_date,#arg_due_date,
                          ls_intructions,#arg_instructions,
                          2188,#arg_urgency,
                          '',#arg_notes,
                          6339,#arg_status
                          program_unit_object.id
                          )
          end # end of pgu_warning_collection.each
        end # end of pgu_warning_collection.present?
      end # end of participation_status == 6043

    end # end of method


     def self.is_program_unit_participation_status_closed_for_more_than_30days(arg_program_unit_id)
      result = ""
        participation_status = where("program_unit_id = ?", arg_program_unit_id).order(id: :desc).first
        if participation_status.present? && participation_status.participation_status == 6044
           if participation_status.action_date + 30.days < Date.today
            result = true
           else
            result = false
           end
        end
        return result
     end


      def self.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
          step1 = ProgramUnitParticipation.joins("INNER JOIN program_units
                                                  ON program_unit_participations.program_unit_id = program_units.id
                                                  INNER JOIN program_unit_members
                                                  ON (program_unit_members.program_unit_id = program_units.id
                                                      AND program_unit_members.member_status = 4468)
                                                ")
          step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
          step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
          step4 = step3.where("program_unit_participations.participation_status = 6043").count

          if step4 > 0
            return true
          else
            return false
          end
      end

      def self.is_the_client_present_in_open_program_unit_for_a_given_service_program_and_active?(arg_client_id, arg_service_program_id)
          step1 = ProgramUnitParticipation.joins("INNER JOIN program_units
                                                  ON program_unit_participations.program_unit_id = program_units.id
                                                  INNER JOIN program_unit_members
                                                  ON (program_unit_members.program_unit_id = program_units.id
                                                      AND program_unit_members.member_status = 4468)
                                                ")
          step2 = step1.where("program_unit_members.client_id = ? and program_units.service_program_id = ?",arg_client_id,arg_service_program_id)
          step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
          step4 = step3.where("program_unit_participations.participation_status = 6043").count

          if step4 > 0
            return true
          else
            return false
          end
      end


      def self.get_program_unit_participation_status(arg_program_unit_id)
        participation_statuses = where("program_unit_id = ?", arg_program_unit_id).order(id: :desc)
        return participation_statuses.present? ? participation_statuses.first.participation_status : nil
      end
end
