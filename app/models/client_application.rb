class ClientApplication < ActiveRecord::Base
has_paper_trail :class_name => 'ClientApplicationVersion',:on => [:update, :destroy]


	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field
    attr_accessor :self_client_id
    attr_accessor :selected_service_program
    attr_accessor :application_index_link_path
    attr_accessor :program_unit_processing_location


HUMANIZED_ATTRIBUTES = {
      application_date: "Application Date",
      application_origin: "Application Origin",
      application_received_office: "Application Received At",
      self_client_id: "Primary Contact"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


    has_many :application_service_programs, dependent: :destroy
    has_many :application_members, dependent: :destroy
    # validations
    validates_presence_of :application_date,:application_received_office, message: "is required."


    validate :valid_application_date?

    def valid_application_date?
        DateService.valid_date_before_today?(self,application_date,"Application Date")
    end



    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    #Manoj 09/06/2014
    # Application - Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps
      %w[client_application_first client_application_second client_application_third client_application_fourth client_application_fifth client_application_last]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end

    def get_process_object
      self.process_object = steps[steps.index(current_step)-1]
    end


    # Application - Multi step form creation of data. - End


    def self.can_this_application_be_completed(arg_application_id)


      client_application_object = ClientApplication.find(arg_application_id)
      #  Rule 1: Application Members should be there.
      application_members_collection = client_application_object.application_members
      ls_message = "SUCCESS"
      if application_members_collection.present?
        if application_members_collection.size >= 2
          ls_message = "SUCCESS"
        else
          ls_message = "Minimum two members are needed to set up the relationship."
        end
      else
         ls_message = "There are no application members."
      end


      # Rule 2 : Primary Applicant should be there.
      if  ls_message == "SUCCESS"
        if application_members_collection.present?
          primary_applicant_collection = ApplicationMember.get_primary_applicant(arg_application_id)
          if primary_applicant_collection.present?
            ls_message == "SUCCESS"
          else
             ls_message = "Primary applicant is not selected."
          end
        end
      end

      # Rule 3 : all relations between members should be set.
      if  ls_message == "SUCCESS"
          l_members_count = client_application_object.application_members.count
          l_expected_relationship_count = l_members_count * (l_members_count - 1)

          l_db_relationships = ClientRelationship.get_apllication_member_relationships(arg_application_id)
          l_db_relationship_count = l_db_relationships.size
          if l_expected_relationship_count == l_db_relationship_count
             ls_message = "SUCCESS"
          else
             ls_message = "Not all relationships are added, add all relationships between members."
          end
      end

      # Rule 4 : Application Questions should be answered.
      if ls_message == "SUCCESS"
          client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(arg_application_id)
          if client_application_question_answers_y_n.present?
             ls_message = "SUCCESS"
          else
             ls_message = "Application questions are not answered."
          end
      end

      # logger.debug "ls_message = #{ls_message.inspect}"
      return ls_message

    end




    # def get_application_disposition_status
    #   ls_out = ""
    #   if application_disposition_status.present?
    #     case application_disposition_status
    #       when 6017
    #         ls_out = "ACCEPTED"
    #       when 6018
    #         ls_out = "REJECTED"
    #       else
    #          ls_out = " "
    #     end
    #   end
    #   return ls_out
    # end


    def self.get_applications_list(arg_client_id)
      # show the applications where Focus client is involved.
      application_list = self.where("id in (select client_application_id from application_members where client_id = ?)",arg_client_id)
    end

    def self.get_completed_applications_list(arg_client_id)
      # show completed applications for the given client ID
      step1 = ClientApplication.joins("INNER JOIN application_members
                                      on (client_applications.id = application_members.client_application_id
                                          and client_applications.application_status = 5942
                                         )
                                      ")
      step2 = step1.where("application_members.client_id = ?",arg_client_id)


      # all_applications_for_client = self.where("id in (select client_application_id from application_members where client_id = #{arg_client_id})")
      # completed_applications_for_client = all_applications_for_client.where("application_status = 5942")
      completed_applications_for_client = step2
      return completed_applications_for_client

    end

    def self.save_application_action_and_service_programs(arg_params,arg_application_id,arg_service_program_array = [])

    # description :
    # Save
    #1. client_application
    #2. application_service_programs
    #3. program_units
    #4. program_unit_members
    # Handling in one transaction

        return_hash = {}
        program_unit_object = ""
        return_hash[:message] = "SUCCESS"
        return_hash[:program_unit_id] = 0
        client_application_object = ClientApplication.find(arg_application_id)
        #  set values to fields.
        client_application_object.application_disposition_status = arg_params[:application_disposition_status]
        client_application_object.disposition_date  = Time.now.to_date
        client_application_object.application_disposition_reason = arg_params[:application_disposition_reason]
        if arg_params[:application_disposition_status].to_i == 6018
          # Rejected
            if client_application_object.save
                 # since application is rejected - delete any records for that application in application_service_programs table.
                ApplicationServiceProgram.where("client_application_id = ?",arg_application_id).destroy_all
                # since application is rejected - delete any records for that application in application_service_programs table.
                ProgramUnitMember.where("program_unit_id in (select id from program_units where client_application_id = ?)",arg_application_id).destroy_all
                ProgramUnit.where("client_application_id = ?",arg_application_id).destroy_all
                return_hash[:message] = "SUCCESS"
            else
                return_hash[:message] = client_application_object.errors.full_messages[0]
            end
        else
          # loop through service program array and add those many program units
      application_screening_object = ApplicationScreening.where("client_application_id = ?",arg_application_id).first
      begin
        ActiveRecord::Base.transaction do
          #table1 - vlirnt_applications
          client_application_object.save!
          arg_service_program_array.each do |arg_srvc_prgm|
            # table2. application_service_programs.
            # Insert/update
            app_srvc_prgm_collection = ApplicationServiceProgram.where("client_application_id = ? and service_program_id = ?",client_application_object.id,arg_srvc_prgm)
            if app_srvc_prgm_collection.count == 0
              app_srvc_prgm_object = ApplicationServiceProgram.new
              app_srvc_prgm_object.client_application_id = arg_application_id
              app_srvc_prgm_object.service_program_id = arg_srvc_prgm
              app_srvc_prgm_object.status = 4000  # Pending
              app_srvc_prgm_object.save!
            end
            #3.program Unit.
            #4.Program Unit Members
            program_unit_object_collection = ProgramUnit.where("client_application_id = ? and service_program_id = ?",arg_application_id,arg_srvc_prgm)
            denied_program_unit_collection = ProgramUnit.where("client_application_id = ? and service_program_id = ? and disposition_status = 6041",arg_application_id,arg_srvc_prgm)
            # No program units OR only DEnied Program Units - then create new program Unit
            if program_unit_object_collection.blank? || denied_program_unit_collection.present?
              program_unit_object = ProgramUnit.new
              program_unit_object.client_application_id = arg_application_id
              program_unit_object.service_program_id = arg_srvc_prgm
              program_unit_object.processing_location = arg_params[:program_unit_processing_location]
              program_unit_object.case_type = application_screening_object.determined_case_type
              program_unit_object.save!
              # change the program unit state to complete
              program_unit_object.complete
              application_members_collection = client_application_object.application_members
              application_members_collection.each do |arg_member|
                l_program_unit_member_object = ProgramUnitMember.new
                l_program_unit_member_object.program_unit_id = program_unit_object.id
                l_program_unit_member_object.client_id = arg_member.client_id
                l_program_unit_member_object.member_of_application = "Y"
                l_program_unit_member_object.member_status = 4468 # Active
                application_primary_contact = PrimaryContact.get_primary_contact(arg_application_id, 6587)
                if application_primary_contact.present?
                  PrimaryContactService.save_primary_contact(program_unit_object.id, 6345, application_primary_contact.client_id)
                end
                # if arg_member.primary_member == "Y"
                #   l_program_unit_member_object.primary_beneficiary = "Y"
                # else
                #   l_program_unit_member_object.primary_beneficiary = "N"
                # end
                l_program_unit_member_object.save!
              end
            else
               program_unit_object = program_unit_object_collection.first
            end

          end #End of service program Array.
           return_hash[:program_unit_id] = program_unit_object.id
        end # end of ActiveRecord::Base.transaction do
          return_hash[:message] = "SUCCESS"

      rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("ClientApplication-Model","save_application_action_and_service_programs",err,AuditModule.get_current_user.uid)
        msg = "Failed to save application and creating program units - for more details refer to error ID: #{error_object.id}."
        return_hash[:message] = msg
      end

        end  # end of Accept

        return return_hash
    end



  def self.get_application_date(arg_application_id)
    l_object = where("id = ?",arg_application_id).first
    ldt_application_date = l_object.application_date
    return ldt_application_date
  end

  def self.can_new_application_be_created?(arg_focus_client_id)
    can_create_application = true
    # Rule : If client is associated with Incomplete application - use that application only.
    # are there any applications this client is associated with
    step1 = ClientApplication.joins("INNER JOIN application_members
                                     ON client_applications.id = application_members.client_application_id
                                     ")
    step2 = step1.where("application_members.client_id = ?
                         and client_applications.application_status = 5943",
                        arg_focus_client_id
                        )
    client_applications_collections = step2
    if client_applications_collections.present?
      can_create_application = false
    else
       can_create_application = true
    end

    return can_create_application

  end

  def self.can_new_application_be_created_for_household?(arg_household_id)
    lb_can_create_application = false
    # Rule : If Household is associated with Not disposed application - use that application only.
    # are there any applications this client is associated with

    # client_applications_collections = ClientApplication.where("household_id = ? and application_disposition_status in (6017,6018)",arg_household_id)
    client_applications_collections = ClientApplication.where("household_id = ?",arg_household_id).order("id DESC")
    if client_applications_collections.present?
      client_application_object = client_applications_collections.first
      if [6017,6018,6041].include?(client_application_object.application_disposition_status)
        lb_can_create_application = true
      end
    else
      lb_can_create_application = true
    end
    return lb_can_create_application
  end




 def self.can_client_application_be_modified?(arg_application_id)
    can_be_modified = true
    selected_application = ClientApplication.find(arg_application_id)

    if selected_application.application_disposition_status.blank?
        can_be_modified = true
    else
        if selected_application.application_disposition_status == 6018 # Rejected
          can_be_modified = false
        else
            # After accepting application 30 days to process and give service program
            # Accepted
            # l_days = SystemParam.get_app_screening_days_limit()
            # if (Date.today - selected_application.application_date).to_i > l_days
            #   can_be_modified = false
            # else
            #   can_be_modified = true
            # end
            # If application has resulted in Program unit - no need of modifying it again ..let them deny the program unit and add another application
            program_units_collection = ProgramUnit.where("client_application_id = ?",arg_application_id)
            if program_units_collection.present?
              can_be_modified = false
            else
              can_be_modified = true
            end
        end
    end

    return can_be_modified
 end

 def self.get_logged_in_user_updated_incomplete_applications(arg_user_id)
    # ClientApplication.where("updated_by = ? and application_status = 5943",arg_user_id).order("updated_at DESC")
    step1 = ClientApplication.joins("client_applications
                                     left outer join
                                     households
                                     ON client_applications.household_id = households.id
                                     ")
    step2 = step1.where("client_applications.intake_worker_id = ?",arg_user_id)
    step3 = step2.select("client_applications.*, households.name").order("client_applications.updated_at DESC")
 end

  def self.get_application_id(arg_household_id)
    result = nil
    client_applications = where("household_id = ?",arg_household_id).order("id desc")
    if client_applications.present?
      result = client_applications.first.id
    end
    return result
  end

  def self.get_household_id(arg_application_id)
    household_id = nil
    client_applications = where("id = ?",arg_application_id)
    if client_applications.present?
      household_id = client_applications.first.household_id
    end
    return household_id
  end

  attr_writer :application_processing_current_step,:application_processing_object

    def app_processing_steps
      user_role = AuditModule.get_current_user.get_role_id()
      # %w[application_processing_first application_processing_second application_processing_third application_processing_fourth application_processing_fifth application_processing_sixth application_processing_last]
      initial_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = nil
        steps_array = RubyElement.get_secondary(853,user_role,6350).map {|i| i.element_name }
      ActiveRecord::Base.logger = initial_logger
      return steps_array
    end

    def application_processing_current_step
      @application_processing_current_step || app_processing_steps.first
    end

    def application_processing_next_step
      self.application_processing_current_step = app_processing_steps[app_processing_steps.index(application_processing_current_step)+1]
    end

    def application_processing_previous_step
      self.application_processing_current_step = app_processing_steps[app_processing_steps.index(application_processing_current_step)-1]
    end

    def application_processing_first_step?
      application_processing_current_step == app_processing_steps.first
    end

    def application_processing_last_step?
      application_processing_current_step == app_processing_steps.last
    end

    def get_application_processing_object
      self.application_processing_object = app_processing_steps[app_processing_steps.index(application_processing_current_step)-1]
    end

    def get_application_processing_wizard_step_number
      current_step = app_processing_steps.index(application_processing_current_step) + 1
      total_steps = app_processing_steps.count
      step_number = "Step #{current_step} of #{total_steps}"
    end

    # def self.is_there_an_application_with_disposition_status(arg_application_id, arg_application_disposition_status)
    #   result = false
    #   client_application = ClientApplication.where("id = ?",arg_application_id)
    #   if client_application.present? && client_application.first.application_disposition_status == arg_application_disposition_status
    #     result = true
    #   end
    #   return result
    # end

    # def self.is_the_application_accepted?(arg_application_id)
    #   is_there_an_application_with_disposition_status(arg_application_id, 6017)
    # end

    # def self.is_the_application_rejected?(arg_application_id)
    #   is_there_an_application_with_disposition_status(arg_application_id, 6018)
    # end

    # def self.is_this_households_first_application?(arg_household_id)
    #     lb_households_first_application = false
    #     hh_client_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",arg_household_id)
    #     if hh_client_application_collection.present?
    #       if hh_client_application_collection.size == 1
    #         hh_client_application_collection = true
    #       end
    #     end
    #     return lb_households_first_application
    # end

    def self.get_applications_for_household(arg_household_id)
      ClientApplication.where("household_id = ?",arg_household_id).order("id DESC")
    end


end
