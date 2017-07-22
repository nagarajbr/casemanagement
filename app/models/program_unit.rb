# Manoj Patil
class ProgramUnit < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramUnitVersion',:on => [:update, :destroy]

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field

  has_many :program_unit_members
  has_many :program_wizards
  has_many :program_unit_participations

  attr_accessor :index_link_path
  attr_accessor :beneficiary_client_id
  # attr_accessor :pgu_family_comp_diff_from_application
  attr_accessor :pgu_family_comp_same_as_application
  attr_accessor :show_case_transfer_link


  # validate  :rejection_reason_required_if_rejecting,:on => :update
  # after_update :processing_office_changed

  # State machine state management start Manoj 07/24/2014
  state_machine :state, :initial => :incomplete do
  audit_trail context: [:created_by, :reason]
     # audit_trail context: :created_by

    state :incomplete, value: 6164
    state :complete, value: 6165
    state :requested, value: 6373
    state :rejected, value: 6167
    state :approved, value: 6166

    event :complete do
        transition :incomplete => :complete
    end

    event :request do
          transition :complete => :requested
    end

    event :approve do
        transition :requested => :approved
    end

    event :reject do
        transition :requested => :rejected
    end

    event :reject_to_complete do
        transition :rejected => :complete
    end

  end
  # State machine state management end Manoj 07/24/2014

  def created_by
    # updated user id
     AuditModule.get_current_user.uid
  end

    def rejection_reason_required_if_rejecting
       lb_return = true
       if self.state == 6167 # Approval REjected

          if self.reason.blank?
             self.errors.add(:reason, "is required.")
             lb_return = false
           end
       end
       return lb_return
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

  def self.get_open_client_program_units(arg_client_id)
      # show the program ID associated with focus client.
      step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON  program_units.id =  program_unit_members.program_unit_id
                                 INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id
                               ")
      step2 = step1.where("program_unit_members.client_id =? and program_unit_participations.participation_status = 6043",arg_client_id)
      step3 = step2.where("program_unit_participations.id = (select max(id) from program_unit_participations A where A.program_unit_id = program_unit_participations.program_unit_id)")
      step4 = step3.order("program_units.id DESC")
      return_program_units_collection =  step4
      return return_program_units_collection
  end

    def self.get_client_program_units(arg_client_id)
      # show the program ID associated with focus client.
      step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON  program_units.id =  program_unit_members.program_unit_id")
      step2 = step1.where("program_unit_members.client_id =?",arg_client_id)
      step3 = step2.order("program_units.id DESC")
      return_program_units_collection =   step3
      return return_program_units_collection

    end



  #Manoj 09/06/2014
    # Program Unit- Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps
      # %w[program_unit_first program_unit_second program_unit_third program_unit_fourth program_unit_fifth program_unit_sixth program_unit_seventh program_unit_last]
      %w[program_unit_first program_unit_second program_unit_third program_unit_fourth program_unit_seventh program_unit_last]
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


    # Program Unit - Multi step form creation of data. - End




    # Add Program unit members.
    # def self.add_program_unit_members(arg_program_unit_id)
    #   # Description: Add Application Members to Program_unit_members.
    #   l_program_unit_object = ProgramUnit.find(arg_program_unit_id)
    #   l_program_unit_member_count = ProgramUnitMember.where("program_unit_id = ?", arg_program_unit_id).count
    #   ls_message = "SUCCESS"
    #   if l_program_unit_member_count == 0
    #     # Add Application Members to Program_unit_members.
    #     application_member_collection = ApplicationMember.where("client_application_id = ?",l_program_unit_object.client_application_id)
    #     application_member_collection.each do |arg_member|
    #       l_program_unit_member_object = ProgramUnitMember.new
    #       l_program_unit_member_object.program_unit_id = arg_program_unit_id
    #       l_program_unit_member_object.client_id = arg_member.client_id
    #       l_program_unit_member_object.member_of_application = "Y"
    #       l_program_unit_member_object.member_status = 4468 # Active

    #       if l_program_unit_member_object.save
    #          ls_message = "SUCCESS"
    #       else
    #          ls_message = l_program_unit_member_object.errors.full_messages.last
    #          break
    #       end
    #     end
    #   else
    #     ls_message = "SUCCESS"
    #   end

    #   return ls_message
    # end

    def self.complete_program_unit_process(arg_program_unit_id)
      # 1. Update Program Unit disposition Status
      # 2. Create Payment Unit
      msg = "SUCCESS"
      program_unit_object = ProgramUnit.find(arg_program_unit_id)
      program_unit_object.program_unit_status = 5942 # complete -5942
      program_unit_object.reason = nil

          if program_unit_object.save
            if program_unit_object.state == 6164
              # Rule : If workflow state is Incomplete or rejected  mark it complete.
              lb_workflow_save = program_unit_object.complete
              if lb_workflow_save == false
                msg = program_unit_object.errors.full_messages.last
              end
            end

            if program_unit_object.state == 6167
              # Rule : If workflow state is Incomplete or rejected  mark it complete.
              lb_workflow_save = program_unit_object.reject_to_complete
              if lb_workflow_save == false
                msg = program_unit_object.errors.full_messages.last
              end
            end

            msg == "SUCCESS"
          else
            msg = program_unit_object.errors.full_messages.last
          end

        return msg
    end



    def self.get_client_program_units_list(arg_client_id)
      # all_program_units_for_client = self.where("id in (select program_unit_id from program_unit_members where client_id = #{arg_client_id})")
      # return all_program_units_for_client
      step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON program_units.id = program_unit_members.program_unit_id")
      step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
      step3 = step2.order("program_units.id DESC")
      all_program_units_for_client =   step3
      return all_program_units_for_client
    end

    # def self.get_completed_program_units_for_focus_client(arg_client_id)
    #    all_program_units_for_client = self.where("id in (select program_unit_id from program_unit_members where client_id = ?)" ,arg_client_id)
    #    completed_program_units_for_client = all_program_units_for_client.where("program_unit_status = 5942")
    #   return completed_program_units_for_client
    # end



    def self.allow_program_unit_to_be_modified?(arg_program_unit_id)
        #  Rule : Eligibility determination can be done only before disposition status populated.
        l_boolean = true
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
        if  program_unit_object.disposition_status.blank?
           l_boolean = true
        else

           # Give 30 days if it was denied /approved in error to correct.
            if (Date.today - program_unit_object.disposition_date.to_date).to_i > 30
             l_boolean = false
            else
              l_boolean = true
            end

            # check the latest participation status - if close you cannot modify program unit.
            if l_boolean == true
              program_participation_collection = program_unit_object.program_unit_participations
              if program_participation_collection.present?
                sorted_participation_list = program_participation_collection.order("updated_at DESC")
                participation_object = sorted_participation_list.first
                if participation_object.participation_status == 6044 # close
                   l_boolean = false
                else
                   l_boolean = true
                end
              else
                 l_boolean = true
              end
            end

        end
        return l_boolean
    end


    # def self.enable_disable_close_program_unit_link(arg_program_unit_id)
    #     #  Rule : Eligibility determination can be done only before disposition status populated.
    #     l_boolean = true
    #     program_unit_object = ProgramUnit.find(arg_program_unit_id)
    #     #  find the latest program_participation status - if it is Open - then only make close link visible.
    #     program_participation_collection = ProgramUnitParticipation.where("program_unit_id = ?",arg_program_unit_id).order("id DESC")
    #     if program_participation_collection.present?
    #         program_participation_object = program_participation_collection.first
    #         if program_participation_object.participation_status == 6043 # Open
    #             l_boolean = true
    #         else
    #             l_boolean = false
    #         end
    #     else
    #        l_boolean = false
    #     end

    #     return l_boolean
    # end

    #  def self.enable_disable_reopen_program_unit_link(arg_program_unit_id)
    #     #  Rule : Eligibility determination can be done only before disposition status populated.
    #     l_boolean = true
    #     program_unit_object = ProgramUnit.find(arg_program_unit_id)
    #     #  find the latest program_participation status - if it is Open - then only make close link visible.
    #     program_participation_collection = ProgramUnitParticipation.where("program_unit_id = ?",arg_program_unit_id).order("id DESC")
    #     if program_participation_collection.present?
    #         program_participation_object = program_participation_collection.first
    #         if program_participation_object.participation_status == 6044 # Close
    #             l_boolean = true
    #         else
    #             l_boolean = false
    #         end
    #     else
    #        l_boolean = false
    #     end

    #     return l_boolean
    # end


    def self.submit_payment(arg_program_wizard_id)
        program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
        program_wizard_object.submit_date = Time.now
        program_wizard_object.retain_ind = "Y"

        # Update Reeval Date.
        program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
        program_unit_object.reeval_date = Time.now.to_date

        if program_unit_object.service_program_id == 1 # TEA
            payment_return_object = ProgramUnit.create_payment_record(program_wizard_object.run_id,program_wizard_object.run_month,5760)
            if payment_return_object.class.name == "String"
             # msg = "Payment cannot be submitted, because Payment for this month is already processed or you may be submitting retro month payment"
             msg = payment_return_object
             # Rails.logger.debug("submit_payment - #{payment_return_object}")
            else
                begin
                  ActiveRecord::Base.transaction do
                    program_unit_object.save!
                    program_wizard_object.save!
                    payment_return_object.save!
                end

                  msg = "SUCCESS"
                 rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","submit_payment",err,AuditModule.get_current_user.uid)
                    msg = "Failed to submit payment - for more details refer to error ID: #{error_object.id}."

                end
            end
        end

        if program_unit_object.service_program_id == 4 # WORKPAYS
            begin
                  ActiveRecord::Base.transaction do
                    program_unit_object.save!
                    program_wizard_object.save!
                  end
                  msg = "SUCCESS"
            rescue => err
                error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","submit_payment",err,AuditModule.get_current_user.uid)
                msg = "Failed to submit payment - for more details refer to error ID: #{error_object.id}."
            end
        end

        if msg == "SUCCESS"
          # sync program unit member status with program benefit member status
          ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(program_unit_object.id,program_wizard_object.id)
          # update case type of program wizard and sync it to program unit case type
          ProgramWizard.update_case_type(program_wizard_object.id)
          ProgramWizard.update_selected_for_planning_flag_for_program_wizard(program_wizard_object.id)
        end

      return msg
    end



    def self.approve_program_unit(arg_program_unit_id,arg_program_wizard_id)
      msg = nil
      #  Approve Link will be visible - only if program Unbit is not approved before - so I can proceed with updating.
      #  Table 1: program_units
      selected_program_unit = ProgramUnit.find(arg_program_unit_id)
      selected_program_unit.disposition_status = 6042 # Approved
      selected_program_unit.disposition_date = DateTime.now
      selected_program_unit.disposition_reason = 6045 # Approved disposition reason
      selected_program_unit.disposed_by = AuditModule.get_current_user.uid
      selected_program_unit.reeval_date = Time.now.to_date

      # work flow fields
      # selected_program_unit.state =  6166 # Approved
      # selected_program_unit.work_flow_updated_by = AuditModule.get_current_user.uid
      # selected_program_unit.work_flow_updated_date = Time.now.to_date
      selected_program_unit.reason = nil

      #  Table 2 :program_wizards
      program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
      program_wizard_object.submit_date = Time.now
      program_wizard_object.retain_ind = "Y"

      # Table 3 -program_unit_participations
      #  Manage Program Participation status.
      # Get latest status date program participation record.
      program_unit_participation_collection = ProgramUnitParticipation.where("program_unit_id = ?",arg_program_unit_id).order("status_date DESC")
      if program_unit_participation_collection.present?

        program_unit_participation_object = program_unit_participation_collection.first
        #  Check if it is Closed - create New
        if program_unit_participation_object.participation_status == 6043 # Open
          msg = "Unable to approve - There is already program unit with open status available."
        else
          # Close status
          #  can create new.
          l_new_program_unit_participation = ProgramUnitParticipation.new
          l_new_program_unit_participation.program_unit_id = arg_program_unit_id
          l_new_program_unit_participation.participation_status = 6043 # Open
          l_new_program_unit_participation.status_date = Time.now.to_date
          l_new_program_unit_participation.action_date = Time.now.to_date
        end
      else
        # No participation records found - proceed with creating new.
         l_new_program_unit_participation = ProgramUnitParticipation.new
         l_new_program_unit_participation.program_unit_id = arg_program_unit_id
         l_new_program_unit_participation.participation_status = 6043 # Open
         l_new_program_unit_participation.status_date = Time.now.to_date
      end

      # table 4 - program_unit_representatives
      primary_present = ProgramUnitRepresentative.get_primary_representative_count(arg_program_unit_id)
       if primary_present == 0
          primary_rep_object = ProgramUnitRepresentative.set_data_for_primary_representative(arg_program_unit_id)

       end

      # Create Payment record.
        if selected_program_unit.service_program_id == 1 # Only TEA service program we will write payment records from ED screen - 01/09/2014
          client_application_date = ClientApplication.get_application_date(selected_program_unit.client_application_id).strftime("01/%m/%Y").to_date
          current_date = Date.today
          run_month_array = (client_application_date..current_date).group_by(&:month).map { |_,v| v.first.beginning_of_month.to_s }
          begin
              ActiveRecord::Base.transaction do
                # 1.table- payment line item (one or many)
                  payment_return_object = nil
                  run_month_array.each do |payment_date|
                      if payment_date.to_date < current_date
                         #Retro payment for previous months
                         payment_return_object = ProgramUnit.create_payment_record(program_wizard_object.run_id,payment_date,6229)
                      else
                         #Regular payment for current month
                         payment_return_object = ProgramUnit.create_payment_record(program_wizard_object.run_id,payment_date,5760)
                      end
                      if payment_return_object.class.name == "String"
                         msg = "Payment cannot be submitted, because payment for this month is already processed or you may be submitting retro month payment."
                      else
                         payment_return_object.save!
                      end
                  end # run_month_array.each do |payment_date|

                # 2. program unit table
                  selected_program_unit.save!
                # 3.program wizard table
                  program_wizard_object.save!
                # 4. program unit particpatipation
                  l_new_program_unit_participation.save!
                # 5 primary reprsentatives table
                  if primary_present == 0
                    primary_rep_object.save!
                  end
              end #ActiveRecord::Base.transaction do
              msg = "SUCCESS"
          rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","Method Name: approve_program_unit",err,AuditModule.get_current_user.uid)
                  msg = "Failed to activate program unit - for more details refer to error ID: #{error_object.id}."
          end # begin
        end #if selected_program_unit.service_program_id == 1
        if selected_program_unit.service_program_id == 4 # WORKPAYS
          begin
            ActiveRecord::Base.transaction do
              selected_program_unit.save!
              program_wizard_object.save!
              l_new_program_unit_participation.save!
               if primary_present == 0
                  primary_rep_object.save!
               end
            end
            msg = "SUCCESS"
          rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","Method Name: approve_program_unit",err,AuditModule.get_current_user.uid)
              msg = "Failed to activate program unit - for more details refer to error ID: #{error_object.id}."
          end
        end
        if msg == "SUCCESS"
          # sync program unit member status with program benefit member status
          ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(selected_program_unit.id,program_wizard_object.id)
           # update case type of program wizard and sync it to program unit case type
          ProgramWizard.update_case_type(program_wizard_object.id)
          ProgramWizard.update_selected_for_planning_flag_for_program_wizard(program_wizard_object.id)
        end
      return msg

    end

    # Manoj Patil 02/07/2015
    def self.sync_program_unit_member_status_with_benefit_member_status(arg_program_unit_id,arg_program_wizard_id)
      program_benefit_members_collection = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
      program_benefit_members_collection.each do |each_benefit_member|
        # find program_unit_member
        program_unit_member = ProgramUnitMember.get_program_unit_member(arg_program_unit_id,each_benefit_member.client_id)
        if program_unit_member.present?
            program_unit_member.member_status = each_benefit_member.member_status
            program_unit_member.save
        end
      end

      # update program_unit_members status to Inactive Full - if the member is not included in the ED run
      ProgramUnitMember.where("program_unit_id = ? and client_id not in (select client_id from program_benefit_members where program_wizard_id = ?)",arg_program_unit_id,arg_program_wizard_id).update_all("member_status = 4471")
    end

    def self.approve_tea_diversion_program_unit(arg_program_unit_id,arg_program_wizard_id,arg_reimbursement_amount)
      #  Approve Link will be visible - only if program Unbit is not approved before - so I can proceed with updating.
      #  Table 1: program_units
      selected_program_unit = ProgramUnit.find(arg_program_unit_id)
      selected_program_unit.disposition_status = 6042 # Approved
      selected_program_unit.disposition_date =Time.now.to_date
      selected_program_unit.disposition_reason = 6045 # Approved disposition reason
      selected_program_unit.disposed_by = AuditModule.get_current_user.uid
      selected_program_unit.reeval_date = Time.now.to_date

      # work flow fields also.
      # selected_program_unit.state = 6166 # Approved
      # selected_program_unit.work_flow_updated_date =Time.now.to_date
      # selected_program_unit.work_flow_updated_by = AuditModule.get_current_user.uid
      selected_program_unit.reason = nil

      #  Table 2 :program_wizards
      program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
      program_wizard_object.submit_date = Time.now
      program_wizard_object.retain_ind = "Y"

      #  Table 3 :program_benefit_details
      program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence)
      program_benefit_detail = program_benefit_detail_collection.first
      program_benefit_detail.reimbursed_amount = arg_reimbursement_amount


      # Table 4 -program_unit_participations
      #  Manage Program Participation status.
      # Get latest status date program participation record.
      program_unit_participation_collection = ProgramUnitParticipation.where("program_unit_id = ?",arg_program_unit_id).order("status_date DESC")
      if program_unit_participation_collection.present?
        program_unit_participation_object = program_unit_participation_collection.first
        #  Check if it is Closed - create New
        if program_unit_participation_object.participation_status == 6043 # Open
          msg = "Unable to approve - There is already program unit with open status available."
        else
          # Close status
          #  can create new.
          l_new_program_unit_participation = ProgramUnitParticipation.new
          l_new_program_unit_participation.program_unit_id = arg_program_unit_id
          l_new_program_unit_participation.participation_status = 6043 # Open
          l_new_program_unit_participation.status_date = Time.now.to_date
          l_new_program_unit_participation.action_date = Time.now.to_date
          # Close the program Unit
          l_new_program_unit_participation = ProgramUnitParticipation.new
          l_new_program_unit_participation.program_unit_id = arg_program_unit_id
          l_new_program_unit_participation.participation_status = 6044 # Close
          l_new_program_unit_participation.status_date = Time.now.to_date
          l_new_program_unit_participation.action_date = Time.now.to_date

        end
      else
        # No participation records found - proceed with creating new.
         l_new_program_unit_participation_open = ProgramUnitParticipation.new
         l_new_program_unit_participation_open.program_unit_id = arg_program_unit_id
         l_new_program_unit_participation_open.participation_status = 6043 # Open
         l_new_program_unit_participation_open.status_date = Time.now.to_date
         # Close the program Unit
          l_new_program_unit_participation_close = ProgramUnitParticipation.new
          l_new_program_unit_participation_close.program_unit_id = arg_program_unit_id
          l_new_program_unit_participation_close.participation_status = 6044 # Close
          l_new_program_unit_participation_close.status_date = Time.now.to_date
          l_new_program_unit_participation_close.action_date = Time.now.to_date
      end

      # Create Payment record.
        payment_return_object = ProgramUnit.create_tea_diversion_payment_record(program_wizard_object.run_id,program_wizard_object.run_month,arg_reimbursement_amount)
        # logger.debug("payment_return_object - inspect = #{payment_return_object.inspect}")
        # logger.debug("payment_return_object-class - inspect = #{payment_return_object.class.inspect}")
      # Manage transaction.
      if payment_return_object.class.name == "String"
        msg = "Payment cannot be submitted, because payment for this month is already processed or you may be submitting retro or future month payment."
      else
          begin
            ActiveRecord::Base.transaction do
              selected_program_unit.save!
              program_wizard_object.save!
              program_benefit_detail.save!
              l_new_program_unit_participation_open.save!
              l_new_program_unit_participation_close.save!
              payment_return_object.save!
            end
          msg = "SUCCESS"
           rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("In ProgramUnit- Model","Method Name: approve_program_unit",err,AuditModule.get_current_user.uid)
              msg = "Failed to activate program unit - for more details refer to error ID: #{error_object.id}."
          end
      end

       if msg == "SUCCESS"
          # sync program unit member status with program benefit member status
          ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(selected_program_unit.id,program_wizard_object.id)
            # update case type of program wizard and sync it to program unit case type
          ProgramWizard.update_case_type(program_wizard_object.id)
        end



      return msg

    end


    def self.submit_tea_diversion_payment(arg_program_wizard_id,arg_reimbursement_amount)
      #  Table 1 :program_wizard_object
      program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
      program_wizard_object.submit_date = Time.now
      program_wizard_object.retain_ind = "Y"

          #  Table 2 :program_benefit_details
      program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence)
      program_benefit_detail = program_benefit_detail_collection.first
      program_benefit_detail.reimbursed_amount = arg_reimbursement_amount

      # Update Reeval Date.
        program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
        program_unit_object.reeval_date = Time.now.to_date

        payment_return_object = ProgramUnit.create_tea_diversion_payment_record(program_wizard_object.run_id,program_wizard_object.run_month,arg_reimbursement_amount)
        if payment_return_object.class.name == "String"
            msg = "Payment cannot be submitted, because payment for this month is already processed or you may be submitting retro or future month payment."
        else
            begin
                ActiveRecord::Base.transaction do
                  program_unit_object.save!
                  program_wizard_object.save!
                  program_benefit_detail.save!
                  payment_return_object.save!
                end
            msg = "SUCCESS"
             rescue => err
                error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","submit_tea_diversion_payment",err,AuditModule.get_current_user.uid)
                msg = "Failed to submit payment - for more details refer to error ID: #{error_object.id}."
            end
        end

         if msg == "SUCCESS"
          # sync program unit member status with program benefit member status
          ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(program_unit_object.id,program_wizard_object.id)
          # update case type of program wizard and sync it to program unit case type
          ProgramWizard.update_case_type(program_wizard_object.id)
        end

      return msg
    end



    def self.create_payment_record(arg_run_id,arg_run_month,arg_payment_type)
      program_wizard_object = ProgramWizard.where("run_id = ?",arg_run_id).first
      ldt_run_month = arg_run_month
      ldt_current_month = Date.today.strftime("01/%m/%Y").to_date
      # if ldt_run_month >= ldt_current_month
        lb_save = false
        program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)

        # primary_beneficiary_collection = ProgramUnitMember.get_primary_beneficiary(program_wizard_object.program_unit_id)
        # ld_primary_beneficiary_client_id = primary_beneficiary_collection.first.client_id

        primary_contact = PrimaryContact.get_primary_contact(program_wizard_object.program_unit_id, 6345)
         if primary_contact.present?
          ld_primary_beneficiary_client_id = primary_contact.client_id
        end

        program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(program_wizard_object.run_id,program_wizard_object.month_sequence)
        ld_program_benefit_amount = program_benefit_detail_collection.first.program_benefit_amount
        #if run month == current month - then only add record in payment table.
        # else batch will read ED table and write records into payment table.
        # check if this program unit has entry in the payment table for this month.
        program_unit_payment_collection = PaymentLineItem.get_payment_record_for_program_unit_and_run_month(program_wizard_object.program_unit_id,ldt_run_month)
        if program_unit_payment_collection.present?
            # Update
            # what is the payment status
            payment_line_item_object = program_unit_payment_collection.first
            # only generated status record can be modified.
            # If status is sent to AASIS/EDT vendor or paid - there is no need to do anything.
            if payment_line_item_object.payment_status == 6191
                lb_save = true
            end
        else
          # Insert
          payment_line_item_object = PaymentLineItem.new
          lb_save = true
        end

        if lb_save == true

          if program_unit_object.service_program_id == 1  # TEA
            payment_line_item_object.line_item_type = 6175 # TEA
          elsif program_unit_object.service_program_id == 4  # workpays
            payment_line_item_object.line_item_type = 6176 # WORKPAYS
          end
          payment_line_item_object.payment_type = arg_payment_type # REgular#retro
          payment_line_item_object.client_id = ld_primary_beneficiary_client_id
          payment_line_item_object.beneficiary = 6172
          payment_line_item_object.reference_id = program_wizard_object.program_unit_id
          payment_line_item_object.payment_amount = ld_program_benefit_amount
          payment_line_item_object.payment_date = ldt_run_month
          payment_line_item_object.payment_status = 6191 # Generated.
          payment_line_item_object.determination_id = program_wizard_object.run_id
          payment_line_item_object.status = 6201 #Authorized.
          payment_line_item_object.program_unit_id = program_unit_object.id

        end
      # else
      #   payment_line_item_object = nil
      # end

      if payment_line_item_object.present?
          return payment_line_item_object
      else
          return "NOTHING_TO_PROCESS"
      end
    end



    def self.create_tea_diversion_payment_record(arg_run_id,arg_run_month,arg_reimbursement_amount)
      program_wizard_object = ProgramWizard.where("run_id = ?",arg_run_id).first
      ldt_run_month = program_wizard_object.run_month
      ldt_current_month = Date.today.strftime("01/%m/%Y").to_date
      if ldt_run_month == ldt_current_month
        lb_save = false
        program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)

        # primary_beneficiary_collection = ProgramUnitMember.get_primary_beneficiary(program_wizard_object.program_unit_id)
        # ld_primary_beneficiary_client_id = primary_beneficiary_collection.first.client_id

        primary_contact = PrimaryContact.get_primary_contact(program_wizard_object.program_unit_id, 6345)
        if primary_contact.present?
          ld_primary_beneficiary_client_id = primary_contact.client_id
        end

        ld_program_benefit_amount = arg_reimbursement_amount
        #if run month == current month - then only add record in payment table.
        # else batch will read ED table and write records into payment table.
        # check if this program unit has entry in the payment table for this month.
        program_unit_payment_collection = PaymentLineItem.get_payment_record_for_program_unit_and_run_month(program_wizard_object.program_unit_id,ldt_run_month)
        if program_unit_payment_collection.present?

            # Update
            # what is the payment status
            payment_line_item_object = program_unit_payment_collection.first
            # only generated status record can be modified.
            # If status is sent to AASIS/EDT vendor or paid - there is no need to do anything.
            if payment_line_item_object.payment_status == 6191
                lb_save = true
            end
        else

          # Insert
          payment_line_item_object = PaymentLineItem.new
          lb_save = true
        end

        if lb_save == true

          program_unit_object.service_program_id == 3  # TEA Diversion
          payment_line_item_object.line_item_type = 6177 # TEA DIVERSION

          payment_line_item_object.payment_type = 5760 # REgular
          payment_line_item_object.client_id = ld_primary_beneficiary_client_id
          payment_line_item_object.beneficiary = 6172
          payment_line_item_object.reference_id = program_wizard_object.program_unit_id
          payment_line_item_object.payment_amount = ld_program_benefit_amount
          payment_line_item_object.payment_date = ldt_run_month
          payment_line_item_object.payment_status = 6191 # Generated.
          payment_line_item_object.determination_id = program_wizard_object.run_id
          payment_line_item_object.status = 6201 #Authorized.
          payment_line_item_object.program_unit_id = program_unit_object.id
        end
      else

        payment_line_item_object = nil
      end

        if payment_line_item_object.present?

          return payment_line_item_object
        else

          return "NOTHING_TO_PROCESS"
        end
    end







  #   def self.can_create_new_program_unit?(arg_application_id,arg_srvc_prgm)
  #     # Rule 1: Application Member can be open in One TANF service program
  #     # Rule 2: If client is associated with Incomplete program Unit - use that program unit - instead creating duplicate program Unit for the same service program.
  #     return_hash ={}
  #     can_create_program_unit = true
  #     return_hash[:can_create_program_unit] = true
  #     return_hash[:message] = "SUCCESS"

  #     service_pgm_category = ServiceProgram.find(arg_srvc_prgm).svc_pgm_category
  #     application_members_collection = ClientApplication.find(arg_application_id).application_members


  #     application_members_collection.each do |arg_app_member|

  #        #  Query for Application Member can be open in One TANF service program
  #         step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON program_units.id = program_unit_members.program_unit_id")
  #         # step2 = step1.where("program_unit_members.client_id = #{arg_app_member.client_id} and program_units.service_program_id in (select id from service_programs where svc_pgm_category = #{service_pgm_category})")
  #         step2 = step1.where("program_unit_members.client_id = ? and program_units.service_program_id in (select id from service_programs where svc_pgm_category = ?)",arg_app_member.client_id,service_pgm_category)
  #         step3 = step2.select("program_units.id,program_units.program_unit_status,program_units.disposition_status")
  #         l_program_unit_collection = step3

  #         #  query for If client is associated with Incomplete program Unir - use that program unit - instead creating duplicate program Unit for the same service program.
  #         step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON program_units.id = program_unit_members.program_unit_id")
  #         # step2 = step1.where("program_unit_members.client_id = #{arg_app_member.client_id} and program_units.service_program_id = ?",arg_srvc_prgm)
  #         step2 = step1.where("program_unit_members.client_id = ? and program_units.service_program_id = ?",arg_app_member.client_id,arg_srvc_prgm)
  #         step3 = step2.select("program_units.id,program_units.program_unit_status,program_units.disposition_status")
  #         l_program_unit_incomplete_collection = step3
  #         if l_program_unit_incomplete_collection.present?

  #           l_program_unit_incomplete_collection.each do |arg_pgu|
  #             # if Incomplete program unit found -then don't allow.
  #            if arg_pgu.program_unit_status != 5942

  #               can_create_program_unit = false
  #                return_hash[:can_create_program_unit] = can_create_program_unit
  #                client_object = Client.find(arg_app_member.client_id)
  #                return_hash[:message] = "Application member: #{client_object.get_full_name} is already associated with incomplete program unit, manage his benefit using existing program unit."
  #               break
  #             end
  #           end
  #         end


  #         #  Check if there is any Open Program Unit.
  #         if can_create_program_unit == true

  #           if l_program_unit_collection.present?
  #             l_program_unit_collection.each do |arg_pgu|
  #               # Get latest Program Unit status.- If Open Program Unit found don't allow.
  #               pg_status_collection = arg_pgu.program_unit_participations.order("id DESC")
  #               if pg_status_collection.present?
  #                 pg_status_object = pg_status_collection.first
  #                 if pg_status_object.participation_status == 6043
  #                    can_create_program_unit = false
  #                     return_hash[:can_create_program_unit] = can_create_program_unit
  #                     client_object = Client.find(arg_app_member.client_id)
  #                     return_hash[:message] = "Application member: #{client_object.get_full_name} is already associated with open program unit, manage his benefit using existing program unit."
  #                    break
  #                 end
  #               end
  #             end
  #           end
  #         end

  #   end

  #    return return_hash

  # end


  def self.get_current_participation_status(arg_program_unit_id)
    step1 = ProgramUnit.joins("INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id")
    step2 = step1.where("program_units.id = ?",arg_program_unit_id).order("program_unit_participations.id  DESC")
    step3 = step2.select("program_unit_participations.id,program_unit_participations.program_unit_id,program_unit_participations.participation_status")

    if step3.present?
       participation_status_object = step3.first
       ls_current_participation_status = CodetableItem.get_short_description(participation_status_object.participation_status)
    else
      ls_current_participation_status = " "
    end
    return  ls_current_participation_status
  end

   def self.get_current_participation_status_value(arg_program_unit_id)
    step1 = ProgramUnit.joins("INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id")
    step2 = step1.where("program_units.id = ?",arg_program_unit_id).order("program_unit_participations.id  DESC")
    step3 = step2.select("program_unit_participations.id,program_unit_participations.program_unit_id,program_unit_participations.participation_status")

    if step3.present?
       participation_status_object = step3.first
       ls_current_participation_status = participation_status_object.participation_status
    else
      ls_current_participation_status = " "
    end
    return  ls_current_participation_status
  end


  def self.open_tanf_program_unit_found?(arg_client_id,arg_family_type_struct)
    hash_output = {}
    hash_output[:open_tanf_case_found] = false

    # open_tanf_case_found = false
    #service_program = ProgramUnit.find(program_wizard_object.program_unit_id).service_program_id
    service_pgm_category = ServiceProgram.find(arg_family_type_struct.service_program_id).svc_pgm_category
    if service_pgm_category == 6015
      step1 = ProgramUnit.joins("INNER JOIN program_unit_members
                                ON (program_units.id = program_unit_members.program_unit_id
                                    and program_unit_members.member_status = 4468
                                    )
                                INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id"
                                )
      step2 = step1.where("program_unit_members.client_id =? and program_units.id != ?",arg_client_id, arg_family_type_struct.program_unit_id)
      step3 = step2.order("program_unit_participations.id DESC")
      open_program_unit_collection = step3.select("program_unit_participations.*")
      if open_program_unit_collection.present?
        latest_participation_status_object = open_program_unit_collection.first
        if latest_participation_status_object.participation_status == 6043
            program_unit_object = ProgramUnit.find(latest_participation_status_object.program_unit_id)
            hash_output[:open_tanf_case_found] = true
            hash_output[:service_program_id] = program_unit_object.service_program_id
        end
      end

    end

    return hash_output

  end

  def self.has_tanf_client_already_received_payment?(arg_client_id,arg_service_program_id,arg_run_id)
    tanf_client_already_received_payment = false
    program_wizard_object = ProgramWizard.where("run_id = ?",arg_run_id).first
    paid_this_month = InStatePayment.did_client_get_tanf_payment_in_run_month(arg_client_id,program_wizard_object.run_month,arg_service_program_id)
    if paid_this_month == true
      tanf_client_already_received_payment = true
    end
    return tanf_client_already_received_payment

  end

  def self.can_submit_program_run_id?(arg_run_id,arg_month_sequence)
    return_hash = {}
    program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(arg_run_id,arg_month_sequence)
      if program_month_summary_collection.present?
        program_month_summary_object = program_month_summary_collection.first
        if program_month_summary_object.budget_eligible_ind == "Y"
            return_hash[:can_submit] = true
            return_hash[:error_msg] = ""
        else
           return_hash[:can_submit] = false
           return_hash[:error_msg] = "This program unit cannot be submitted because, client is not eligible for benefits."
        end
      else
         return_hash[:can_submit] = false
         return_hash[:error_msg] = "This program unit cannot be submitted because, client is not eligible for benefits."
      end
      if  return_hash[:can_submit] == true
        program_wizard_object = ProgramWizard.where("run_id = ?",arg_run_id).first
        participation_collection = ProgramUnitParticipation.get_participation_status(program_wizard_object.program_unit_id)

        if participation_collection.present?
          participation_object = participation_collection.first
          if participation_object.participation_status == 6044  # close
               return_hash[:can_submit] = false
               return_hash[:error_msg] = "This program unit cannot be submitted because, program unit is closed."
          else
             return_hash[:can_submit] = true
             return_hash[:error_msg] = ""
          end
        else
          return_hash[:can_submit] = true
          return_hash[:error_msg] = ""
        end
      end

      if  return_hash[:can_submit] == true
        primary_rep_found = ProgramUnitRepresentative.primary_representative_found?(program_wizard_object.program_unit_id,program_wizard_object.run_month)
        if primary_rep_found == true
            return_hash[:can_submit] = true
            return_hash[:error_msg] = ""
        else
            return_hash[:can_submit] = false
            return_hash[:error_msg] = "This program unit cannot be submitted because, there is no primary representative for this program unit."
        end
      end


      return return_hash
  end



  def self.can_activate_program_unit?(arg_run_id,arg_month_sequence)
    # Rule . ED should be eligible.
    return_hash = {}
    program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(arg_run_id,arg_month_sequence)
      if program_month_summary_collection.present?
        program_month_summary_object = program_month_summary_collection.first
        if program_month_summary_object.budget_eligible_ind == "Y"
            return_hash[:can_activate] = true
            return_hash[:error_msg] = ""
        else
           return_hash[:can_activate] = false
           return_hash[:error_msg] = "This program unit cannot be activated because, client is not eligible for benefits."
        end
      else
         return_hash[:can_activate] = false
         return_hash[:error_msg] = "This program unit cannot be activated because, client is not eligible for benefits."
      end

      # signed CPP check
      if  return_hash[:can_activate] == true
        program_wizard_object = ProgramWizard.get_program_run_information(arg_run_id).first
        ll_service_program = ProgramWizard.get_service_program_id(program_wizard_object.id)
          if ll_service_program == 1 || ll_service_program == 4
            # ls_return_message = ProgramUnit.check_is_cpp_signed_by_pgu_members(arg_run_id,arg_month_sequence)
            ls_return_message_hash = ProgramUnit.check_is_cpp_signed_by_pgu_members(arg_run_id,arg_month_sequence)

            if ls_return_message_hash["message"] == "SUCCESS"
               return_hash[:can_activate] = true
               return_hash[:error_msg] = ""
            else
               return_hash[:can_activate] = false
               return_hash[:error_msg] = ls_return_message_hash["message"]
               return_hash[:client_id] = ls_return_message_hash["client_id"]
            end
          else
            # tea diversion - check Assessment should be complete.
              ls_return_message_hash = ProgramUnit.check_is_assessment_complete_for_adult_pgu_members(arg_run_id,arg_month_sequence)
              if ls_return_message_hash["message"] == "SUCCESS"
                return_hash[:can_activate] = true
                return_hash[:error_msg] = ""
              else
                return_hash[:can_activate] = false
                return_hash[:error_msg] = ls_return_message_hash["message"]
                return_hash[:client_id] = ls_return_message_hash["client_id"]
              end

          end
      end

      # ED month should be current month check - no retro.
      # if  return_hash[:can_activate] == true
      #   ldt_run_month = program_wizard_object.run_month
      #   ldt_current_month = Date.today.strftime("01/%m/%Y").to_date - 2.months

      #   if ldt_run_month >= ldt_current_month
      #       return_hash[:can_activate] = true
      #       return_hash[:error_msg] = ""
      #   else
      #       return_hash[:can_activate] = false
      #       return_hash[:error_msg] = "You are submitting retro month payment, Payment month should be current month"
      #   end
      # end


      return return_hash
  end





  def self.get_completed_program_units(arg_program_unit_id)
    where("id = ? and program_unit_status = 5942",arg_program_unit_id)
  end

  def self.get_service_program_id(arg_program_unit_id)
    service_program_id = ""
    program_unit_info = find(arg_program_unit_id)
    if program_unit_info.present?
      service_program_id = program_unit_info.service_program_id
    end
    return service_program_id
  end

  def self.get_clients_list_from_program_unit_id(arg_program_unit_id)
    ProgramUnitMember.where("program_unit_id = ?", arg_program_unit_id)
  end

  #  def self.are_there_any_clients_from_program_unit_id_under_18(arg_program_unit_id)
  #   step1 = joins("INNER JOIN PROGRAM_UNIT_MEMBERS  ON (PROGRAM_UNIT_MEMBERS.PROGRAM_UNIT_ID = PROGRAM_UNITS.ID )
  #                  INNER JOIN CLIENTS ON (PROGRAM_UNIT_MEMBERS.CLIENT_ID = CLIENTS.ID)  AND CLIENTS.DOB IS NOT NULL and (EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) < (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))")
  #   step2 = step1.where("PROGRAM_UNITS.ID = ?",arg_program_unit_id)

  #   step2.select("PROGRAM_UNITS.ID").count > 0
  #   #  clients = step3
  #   #  return clients

  # end


   def self.get_clients_name_from_program_unit_id(arg_program_unit_id)
    # ProgramUnitMember.where("program_unit_id = ?", arg_program_unit_id)
    step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON program_units.id = program_unit_members.program_unit_id
                                INNER JOIN clients ON program_unit_members.client_id = clients.id")
    step2 = step1.where("program_unit_members.program_unit_id = ?",arg_program_unit_id)
    step3 = step2.select("rtrim(ltrim(clients.first_name)) as first , rtrim(ltrim(clients.last_name)) as last ")
  end


  def self.can_reopen_program_unit?(arg_program_unit_id)
    can_re_open = true
    service_program = ProgramUnit.find(arg_program_unit_id).service_program_id
    service_pgm_category = ServiceProgram.find(service_program).svc_pgm_category
    if service_pgm_category == 6015
      # TANF category
      # primary_member = ProgramUnitMember.where("program_unit_id = ? and primary_beneficiary = 'Y' ",arg_program_unit_id).first
      program_unit_member_collection = ProgramUnitMember.where("program_unit_id = ?",arg_program_unit_id)
          program_unit_member_collection.each do |each_program_unit_member|
        # check is he present in an open program unit.
        # If he is already present in another open program unit. this program unit cannot be Reopened.
              step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON program_units.id = program_unit_members.program_unit_id
                                INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id"
                                )
              step2 = step1.where("program_unit_members.client_id = ?",each_program_unit_member.client_id)
            # step3 = step2.where("program_unit_participations.participation_status = 6043")
            step3 = step2.select("program_unit_participations.*")
            step4 = step3.order("program_unit_participations.id DESC")

            # open_program_unit_collection_for_primary_client = step3.select("program_unit_participations.participation_status")
            open_program_unit_collection_for_each_client = step4


            if open_program_unit_collection_for_each_client.present?
              latest_participation_status_object = open_program_unit_collection_for_each_client.first

              if latest_participation_status_object.participation_status == 6043 # open
                can_re_open = false
                break
              end
            end # end of open_program_unit_collection_for_primary_client.present?
          end # end of program_unit_member_collection
     end # end of service_pgm_category == 6015
     return can_re_open
  end

def self.can_modify_pgu_action(arg_program_unit_id)
    can_modify_action = true
    # Rule 1: Denied Program units cannot be modified.
    selected_program_unit_object = ProgramUnit.find(arg_program_unit_id)

    if can_modify_action == true
      # Rule 2 : Closed Program Units action after 30 days cannot be modified
         selected_program_unit_object = ProgramUnit.find(arg_program_unit_id)
         program_participation_collection = selected_program_unit_object.program_unit_participations
         if program_participation_collection.present?
            sorted_participation_list = program_participation_collection.order("id DESC")
            participation_object = sorted_participation_list.first
            if participation_object.participation_status == 6044 # Close
                l_days = SystemParam.get_reinstate_days_limit()
                if Time.now.to_date > ( participation_object.action_date + l_days )
                  can_modify_action = false
                else
                  can_modify_action = true
                end
            else
               can_modify_action = true
            end
         else
           can_modify_action = true
         end
    end
    return can_modify_action

end


  # def self.get_primary_representatives(arg_program_unit_id)
  #   ProgramUnitRepresentative.where("program_unit_id=? and representative_type = 4381",arg_program_unit_id)
  # end

  # def self.is_the_service_program_tea_or_workpays(arg_program_unit_id)
  #   service_program_id = get_service_program_id(arg_program_unit_id)
  #   if service_program_id == 1 || service_program_id == 4
  #     return true
  #   else
  #     return false
  #   end
  # end








def self.get_clients_denied
    step1 = joins("INNER JOIN PROGRAM_UNIT_MEMBERS  ON (PROGRAM_UNIT_MEMBERS.PROGRAM_UNIT_ID = PROGRAM_UNITS.ID AND  PROGRAM_UNIT_MEMBERS.PRIMARY_BENEFICIARY = 'Y')
                   INNER JOIN CLIENTS ON (PROGRAM_UNIT_MEMBERS.CLIENT_ID = CLIENTS.ID)
                   INNER JOIN USERS ON  (USERS.UID= PROGRAM_UNITS.UPDATED_BY)
                   INNER JOIN CODETABLE_ITEMS AS LOCATIONS ON ( LOCATIONS.ID = PROGRAM_UNITS.PROCESSING_LOCATION)
                   INNER JOIN LOCAL_OFFICE_INFORMATIONS ON ( LOCAL_OFFICE_INFORMATIONS.CODE_TABLE_ITEM_ID = PROGRAM_UNITS.PROCESSING_LOCATION)
                   INNER JOIN ENTITY_ADDRESSES ON (ENTITY_ADDRESSES.ENTITY_ID = CLIENTS.ID AND ENTITY_ADDRESSES.ENTITY_TYPE = 6150)
                   INNER JOIN ADDRESSES ON (ADDRESSES.ID =  ENTITY_ADDRESSES.ADDRESS_ID AND ADDRESS_TYPE = 4665 AND EFFECTIVE_END_DATE IS NULL)
                   INNER JOIN NOTICE_TEXTS ON (PROGRAM_UNITS.SERVICE_PROGRAM_ID = NOTICE_TEXTS.SERVICE_PROGRAM_ID AND NOTICE_TEXTS.action_type=PROGRAM_UNITS.disposition_status AND NOTICE_TEXTS.action_reason =PROGRAM_UNITS.disposition_reason)")
    step2 = step1.where("program_units.disposition_status = 6041 and (date(program_units.updated_at) = '2014-11-06' or date(program_units.created_at) = '2014-11-06')")

    step3 = step2.select("program_units.id ,
                          rtrim(ltrim(CLIENTS.first_name)) as first_name,
                          rtrim(ltrim(CLIENTS.last_name)) as last_name,
                          PROGRAM_UNIT_MEMBERS.client_id as primary_member_CLIENT_ID,
                          PROGRAM_UNITS.SERVICE_PROGRAM_ID,
                          PROGRAM_UNIT_MEMBERS.PRIMARY_BENEFICIARY,
                          clients.ssn,
                          EXTRACT(YEAR FROM AGE(clients.DOB)) as age,
                          clients.FIRST_NAME AS first,
                          clients.LAST_NAME  AS last,
                          program_units.disposition_status as status,
                          program_units.disposition_reason as reason,
                          TO_CHAR(program_units.disposition_date,'MM/DD/YY') AS status_date,
                          TO_CHAR(program_units.disposition_date,'MM/DD/YY') AS action_date,
                          TO_CHAR(program_units.disposition_date + 30 ,'MM/DD/YY') AS date,
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
                          ADDRESSES.zip_suffix as zip_suffix,
                          notice_texts.notice_text,
                          notice_texts.flag1 ,
                          notice_texts.flag2
")
    clients_denied = step3
    return clients_denied

  end

# Manoj - 02/26/2015 - signed CPP check during activation - start

  def self.check_is_cpp_signed_by_pgu_members(arg_run_id,arg_month_sequence)

    program_wizard_object = ProgramWizard.where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence).first
    return_hash = {}
    ls_message = "SUCCESS"
    return_hash["message"] = ls_message
    clients_with_incomplete_cpp = Array.new
    cpp_signed_members = ProgramUnit.get_non_children_active_benefit_members(program_wizard_object.id)
    if cpp_signed_members.class.name != "String"
        # If it is CHILD ONLY CASE NO CPP IS NEEDED.
        # oNLY NON cHILD ONLY CONSIDERED FOR cpp.
        # only Adults with Mandatory work participation characters need CPP.
        members_requiring_cpp = []
          cpp_signed_members.each do |each_required_member|
            # check if open mandatory work particpation present ?
            # Rule : Only ACtive members with open mandatory work participation status need CPP.
            if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_required_member)
              members_requiring_cpp << each_required_member
            end
          end

          if members_requiring_cpp.size > 0
            # proceed only if any members need CPP.
            # logger.debug("members_requiring_cpp -inspect = #{members_requiring_cpp.inspect}")
              members_requiring_cpp.each do |each_required_member|
                 signed_cpp_collection = CareerPathwayPlan.where("id = (select max(id) from career_pathway_plans
                                                     where career_pathway_plans.state = 6166
                                                     and career_pathway_plans.client_signature = ?
                                                    )
                                              ",each_required_member
                                              )
                if signed_cpp_collection.blank?
                  client_object = Client.find(each_required_member)
                  # ls_message = "To activate the case please create a Career Pathway Plan for : #{client_object.get_full_name} "
                  #  return_hash["message"] = ls_message
                   return_hash["client_id"] = client_object.id
                   clients_with_incomplete_cpp << client_object.get_full_name
                  # break
                end
              end # end of members_requiring_cpp.each
          end # end of members_requiring_cpp.size > 0

        if clients_with_incomplete_cpp.size > 0
            ls_message = "Complete planning step before activating program unit. Approved career plan is not found for the following client(s):"
            ls_client_names = clients_with_incomplete_cpp.map(&:inspect).join(', ')
            ls_message = "#{ls_message} #{ls_client_names}"
            return_hash["message"] = ls_message
        end

    end
    # logger.debug("MNP1 - return_hash in check_is_cpp_signed_by_pgu_members = #{return_hash.inspect}")
    return return_hash
  end

  # def self.check_is_cpp_signed_by_program_unit_members(arg_program_unit_id)
  #   result = true
  #   program_unit_object = ProgramUnit.find(arg_program_unit_id)
  #   cpp_signed_members = ProgramUnit.get_non_children_program_unit_members(arg_program_unit_id)
  #   if cpp_signed_members.class.name != "String"
  #       # If it is CHILD ONLY CASE NO CPP IS NEEDED.
  #       # oNLY NON cHILD ONLY CONSIDERED FOR cpp.
  #       # only Adults with Mandatory work participation characters need CPP.
  #       cpp_signed_members.each do |each_required_member|
  #           # check if open mandatory work particpation present ?
  #           # Rule : Only ACtive members with open mandatory work participation status need CPP.
  #           if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_required_member)
  #               signed_cpp_collection = CareerPathwayPlan.where("id = (select max(id) from career_pathway_plans
  #                                                      where career_pathway_plans.state = 6166
  #                                                      and career_pathway_plans.client_signature = ?
  #                                                     )
  #                                               ",each_required_member
  #                                               )
  #               if signed_cpp_collection.blank?
  #                 #Rails.logger.debug("MNP check_is_cpp_signed_by_program_unit_membersi is false")
  #                 result = false
  #                 break
  #               #else
  #                 #Rails.logger.debug("MNP check_is_cpp_signed_by_program_unit_membersi is true")
  #               end
  #           end
  #       end
  #   end
  #   return result
  # end

  def self.get_non_children_active_benefit_members(arg_program_wizard_id)
    # logger.debug("arg_program_wizard_id in get_non_children_active_benefit_members = #{arg_program_wizard_id}")
    active_client_collection = ProgramBenefitMember.where("program_wizard_id = ? and member_status = 4468",arg_program_wizard_id)
    # logger.debug("active_client_collection in get_non_children_active_benefit_members = #{active_client_collection.inspect}")
    program_wizard_object = ProgramWizard.find(arg_program_wizard_id)

    # find the Case type for Program Wizard
    fts = FamilyTypeService.new
    family_type_struct = FamilyTypeStruct.new
    family_type_struct = fts.determine_family_type_for_program_wizard(arg_program_wizard_id)
    l_pgu_case_type = family_type_struct.case_type_integer

  # 6049;134;"Minor Parent"
  # 6048;134;"Child Only"
  # 6047;134;"Two Parent"
  # 6046;134;"Single Parent"

    if l_pgu_case_type == 6046
      # single Parent
      return_object = ProgramUnit.get_active_adults_from_benefit_members(active_client_collection)
    elsif l_pgu_case_type == 6047
      # Two Parent
       return_object = ProgramUnit.get_active_adults_from_benefit_members(active_client_collection)
    elsif l_pgu_case_type == 6049
      # Minor Parent
       return_object = ProgramUnit.get_active_minor_parents_from_benefit_members(active_client_collection)
    elsif l_pgu_case_type == 6048
      # Child Only
       return_object = "CHILD_ONLY_CASE"
    end

    return return_object

  end

  def self.get_active_adults_from_benefit_members(arg_collection)
    adult_array = []
    arg_collection.each do |each_object|
      l_client_id = each_object.client_id
      if Client.is_adult(l_client_id) == true
        adult_array << l_client_id
      end
    end
    return adult_array
  end

  def self.get_active_minor_parents_from_benefit_members(arg_collection)
    adult_array = []
    arg_collection.each do |each_object|
      l_client_id = each_object.client_id
      if Client.is_adult(l_client_id) == false
          # IS THIS CHILD MINOR PARENT?
          parent_relation_collection = ClientRelationship.where("relationship_type = 5977 and to_client_id = ?",l_client_id)
          if parent_relation_collection.present?
            adult_array << l_client_id
          end
      end
    end
    return adult_array
  end


  # Manoj - 02/26/2015 - signed CPP check during activation - end


    def self.re_open_tanf_program(arg_program_unit_id,arg_action_date,arg_action_reason)
      # 1. Table - program_unit_participation
      program_unit_participation_object = ProgramUnitParticipation.set_participation_record(arg_program_unit_id,arg_action_date,arg_action_reason,6043)
      # 2. Table -program_unit_representatives
      program_unit_representative_object = ProgramUnitRepresentative.set_primary_program_unit_representative_to_active(arg_program_unit_id)
      #3
      program_benefit_members_collection = ProgramBenefitMember.get_latest_program_benefit_members(arg_program_unit_id)
      #4
      program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)
      begin
          ActiveRecord::Base.transaction do

            # 1.
            program_unit_participation_object.save!
            # 2.
            program_unit_representative_object.save!
            #3
            program_unit_members_collection.each do |pu_member|
              program_benefit_members_collection.each do |each_benefit_member|
                if pu_member.client_id == each_benefit_member.client_id
                  pu_member.member_status = each_benefit_member.member_status
                  pu_member.save!
                end
              end # end of program_benefit_members_collection
            end # end of  program_unit_members_collection.
          end # end of ActiveRecord::Base.transaction

          msg = "SUCCESS"
          rescue => err
             error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","re_open_tanf_program",err,AuditModule.get_current_user.uid)
             msg = "Failed to reinstate program unit - for more details refer to error ID: #{error_object.id}."
        end
      return msg
    end


    def self.get_logged_in_user_program_units(arg_user_id)

      my_program_units_collection = ProgramUnit.where("case_manager_id = ? or eligibility_worker_id = ?",arg_user_id,arg_user_id).order("updated_at DESC")

    end


    def self.check_is_assessment_complete_for_adult_pgu_members(arg_run_id,arg_month_sequence)

        program_wizard_object = ProgramWizard.where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence).first
        return_hash = {}
        ls_message = "SUCCESS"
        return_hash["message"] = ls_message
        clients_with_incomplete_assessment_array = Array.new

        active_adult_members = ProgramUnit.get_non_children_active_benefit_members(program_wizard_object.id)
        if active_adult_members.class.name != "String"
          # If it is CHILD ONLY CASE NO assessment IS NEEDED.
          # ONLY NON cHILD ONLY CONSIDERED FOR assessment.
          if active_adult_members.present?
            # proceed only if any members need assessment
              active_adult_members.each do |each_required_member|
                lb_assessment_complete = ClientAssessment.is_assessment_complete_for_client?(each_required_member)
                if lb_assessment_complete == false
                   client_object = Client.find(each_required_member)
                   # ls_message = "Complete the Assessment for : #{client_object.get_full_name} "
                   # return_hash["message"] = ls_message
                   return_hash["client_id"] = client_object.id
                   clients_with_incomplete_assessment_array << client_object.get_full_name
                   # break
                end
              end # end of active_adult_members
          else
            ls_message = "No active members present in the program unit."
            return_hash["message"] = ls_message
          end # end of active_adult_members
        end


        if clients_with_incomplete_assessment_array.size > 0
            ls_message = "Complete assessment step before activating program unit. Assessment is not complete for the following client(s):"
            ls_client_names = clients_with_incomplete_assessment_array.map(&:inspect).join(', ')
            ls_message = "#{ls_message} #{ls_client_names}"
            return_hash["message"] = ls_message
        end
        return return_hash
    end



    def self.get_client_program_units_selected_for_planning(arg_client_id)
      # show the program ID associated with focus client.
      # sELECTED for Planning
      # Active members
      # not disposed/disposed as approved only.
      # step1 = ProgramUnit.joins("INNER JOIN program_wizards
      #                            ON (program_units.id =  program_wizards.program_unit_id
      #                                and selected_for_planning = 'Y')
      #                            INNER JOIN program_benefit_members
      #                            ON  (program_wizards.id = program_benefit_members.program_wizard_id)
      #                            ")
      # step2 = step1.where("program_benefit_members.client_id =?
      #                      and program_benefit_members.member_status = 4468
      #                       and (program_units.disposition_status is null OR program_units.disposition_status = 6042 )",arg_client_id)
      # step3 = step2.order("program_units.id DESC")
      # return_program_units_collection =   step3
      # return return_program_units_collection

      step1 = ProgramUnit.joins("INNER JOIN program_unit_members
                                ON (program_units.id = program_unit_members.program_unit_id)")
      step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
      step3 = step2.order("program_units.id DESC")
      return_program_units_collection =   step3
      return return_program_units_collection

    end

    def self.get_all_open_program_units
      # show the program ID associated with focus client.
      step1 = joins("INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id")
      step2 = step1.where("program_unit_participations.id = (select max(pup.id) from program_unit_participations pup
                                                             where pup.program_unit_id = program_units.id)")
      step3 = step2.where("program_unit_participations.participation_status = 6043")
      step4 = step3.select("program_units.*")
      return step4
    end

    def self.get_all_program_units_opened_from(arg_date)
      step1 = joins("INNER JOIN program_unit_participations on program_units.id = program_unit_participations.program_unit_id
          INNER JOIN program_unit_members on (program_unit_members.program_unit_id = program_units.id and program_unit_members.member_status = 4468)
          INNER JOIN client_relationships on (client_relationships.from_client_id = program_unit_members.client_id and client_relationships.relationship_type = 5977)
          INNER JOIN client_parental_rspabilities on (client_parental_rspabilities.client_relationship_id =  client_relationships.id and client_parental_rspabilities.parent_status = 6076)")
      step2 = step1.where("program_unit_participations.id = (select max(a.id) from program_unit_participations a where a.program_unit_id = program_units.id)
          and program_unit_participations.participation_status = 6043
          and program_unit_participations.status_date >= ?",arg_date)
      program_units_opened = step2.select("distinct program_units.*")
    end

    def self.find_absent_parent_referal(arg_program_unit_id)
      step1 = joins("INNER JOIN program_unit_members on (program_unit_members.program_unit_id = program_units.id and program_unit_members.member_status = 4468)
          INNER JOIN client_relationships on (client_relationships.from_client_id = program_unit_members.client_id and client_relationships.relationship_type = 5977)
          INNER JOIN client_parental_rspabilities on (client_parental_rspabilities.client_relationship_id =  client_relationships.id
           and client_parental_rspabilities.parent_status = 6076 and client_parental_rspabilities.child_support_referral = 4579)")
      step2 = step1.where("program_units.id = ?",arg_program_unit_id).count > 0
    end

    def self.is_there_an_absent_parent(arg_program_unit_id)
      step1 = joins("INNER JOIN program_unit_members on (program_unit_members.program_unit_id = program_units.id and program_unit_members.member_status = 4468)
          INNER JOIN client_relationships on (client_relationships.from_client_id = program_unit_members.client_id and client_relationships.relationship_type = 5977)
          INNER JOIN client_parental_rspabilities on (client_parental_rspabilities.client_relationship_id =  client_relationships.id
           and client_parental_rspabilities.parent_status = 6076)")
      step2 = step1.where("program_units.id = ?",arg_program_unit_id).count > 0
    end

    def self.get_processing_local_office_name(arg_program_unit_id)
      ls_local_office = ""
      program_unit_object = find(arg_program_unit_id)
      if program_unit_object.present?
        ls_local_office = CodetableItem.get_short_description(program_unit_object.processing_location)
      end
      return ls_local_office
    end

    def self.get_open_program_unit_for_client(arg_client_id)
      program_unit_id = nil
      step1 = joins("INNER JOIN program_unit_participations
                    ON program_unit_participations.program_unit_id = program_units.id
                    INNER JOIN program_unit_members
                    ON program_unit_members.program_unit_id = program_units.id
                  ")
      step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
      step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
      step4 = step3.where("program_unit_participations.participation_status = 6043").select("program_units.*")

      if step4.present?
        program_unit_id = step4.first.id
      end
      return program_unit_id
    end

    def self.get_open_work_pays_program_unit_for_client(arg_client_id)
      program_unit_id = nil
      step1 = joins("INNER JOIN program_unit_participations
                    ON program_unit_participations.program_unit_id = program_units.id
                    INNER JOIN program_unit_members
                    ON program_unit_members.program_unit_id = program_units.id
                  ")
      step2 = step1.where("program_unit_members.client_id = ? and program_units.service_program_id = 4",arg_client_id)
      step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
      step4 = step3.where("program_unit_participations.participation_status = 6043").select("program_units.*")

      if step4.present?
        program_unit_id = step4.first.id
      end
      return program_unit_id
    end

    def self.get_program_unit_form_program_wizard_id(arg_program_wizard_id)
      step1 = joins("INNER JOIN program_wizards
                    ON program_wizards.program_unit_id = program_units.id
                  ")
      step2 = step1.where("program_wizards.id = ?",arg_program_wizard_id)
      if step2.present?
        step2 = step2.select("program_units.*").first
      end
      return step2
    end



    def self.get_non_children_program_unit_members(arg_program_unit_id)
        # logger.debug("arg_program_wizard_id in get_non_children_active_benefit_members = #{arg_program_wizard_id}")
        active_client_collection = ProgramUnitMember.where("program_unit_id = ? and member_status = 4468",arg_program_unit_id)


        # find the Case type for Program Wizard
        fts = FamilyTypeService.new
        family_type_struct = FamilyTypeStruct.new
        family_type_struct = fts.determine_family_type_for_program_unit(arg_program_unit_id)
        l_pgu_case_type = family_type_struct.case_type_integer

      # 6049;134;"Minor Parent"
      # 6048;134;"Child Only"
      # 6047;134;"Two Parent"
      # 6046;134;"Single Parent"

        if l_pgu_case_type == 6046
          # single Parent
          return_object = ProgramUnit.get_active_adults_from_benefit_members(active_client_collection)
        elsif l_pgu_case_type == 6047
          # Two Parent
           return_object = ProgramUnit.get_active_adults_from_benefit_members(active_client_collection)
        elsif l_pgu_case_type == 6049
          # Minor Parent
           return_object = ProgramUnit.get_active_minor_parents_from_benefit_members(active_client_collection)
        elsif l_pgu_case_type == 6048
          # Child Only
           return_object = "CHILD_ONLY_CASE"
        end

        return return_object

    end


    # def self.check_is_cpp_completed_by_program_unit_members(arg_program_unit_id)

    # def self.get_work_characteristic_for_open_program_unit
    #         month_start_date = nil
    #         month_end_date = nil
    #         a = Date.today
    #         month_start_date = a.beginning_of_month
    #         month_end_date = a.end_of_month


    #          step1 = joins("INNER JOIN program_unit_members ON( program_unit_members.program_unit_id=program_units.id
    #                                                             AND program_unit_members.MEMBER_STATUS = 4468
    #                                                            )
    #                         INNER JOIN program_unit_participations ON(program_units.id = program_unit_participations.program_unit_id
    #                                                                   and program_unit_participations.id = (SELECT max(a.id)
    #                                                                                                         FROM program_unit_participations as a
    #                                                                                                         where a.program_unit_id = program_units.id )
    #                                                                                                               and program_unit_participations.participation_status = 6043
    #                                                                  )
    #                        INNER JOIN client_characteristics on(program_unit_members.client_id = client_characteristics.client_id
    #                                                             AND client_characteristics.characteristic_type= 'WorkCharacteristic'
    #                                                              AND client_characteristics.id = (select client_characteristics.id
    #                                                                                               FROM client_characteristics
    #                                                                                               WHERE client_characteristics.client_id = program_unit_members.client_id
    #                                                                                               order by client_characteristics.start_date desc limit 1
    #                                                                                               )
    #                                                             )
    #                        ")
    #          step2 = step1.where("client_characteristics.end_date between ? and ?  or (client_characteristics.end_date is null and client_characteristics.characteristic_id not in (5667,5700,5701)) ",month_start_date ,month_end_date )

    #          step3 = step2.select("program_unit_members.client_id,program_units.eligibility_worker_id,client_characteristics.end_date,program_units.id,program_units.eligibility_worker_id,program_units.case_manager_id")
    #          return step3
    #    end

      def self.check_is_cpp_completed_by_program_unit_members(arg_program_unit_id)
        result = true
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
        cpp_signed_members = ProgramUnit.get_non_children_program_unit_members(arg_program_unit_id)
        if cpp_signed_members.class.name != "String"
            # If it is CHILD ONLY CASE NO CPP IS NEEDED.
            # oNLY NON cHILD ONLY CONSIDERED FOR cpp.
            # only Adults with Mandatory work participation characters need CPP.
            cpp_signed_members.each do |each_required_member|
                # check if open mandatory work particpation present ?
                # Rule : Only ACtive members with open mandatory work participation status need CPP.
                if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_required_member)
                    signed_cpp_collection = CareerPathwayPlan.where("id = (select max(id) from career_pathway_plans
                                                                           where career_pathway_plans.client_signature = ?
                                                                           and career_pathway_plans.state = 6373
                                                                           )
                                                    ",each_required_member
                                                    )
                    if signed_cpp_collection.blank?
                      #Rails.logger.debug("MNP check_is_cpp_signed_by_program_unit_membersi is false")
                      result = false
                      break
                    #else
                      #Rails.logger.debug("MNP check_is_cpp_signed_by_program_unit_membersi is true")
                    end
                end
            end
        end
        return result
    end


     def self.get_completed_cpp_for_adult_program_unit_members(arg_program_unit_id)
        latest_signed_cpp_for_program_unit_clients = Array.new
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
        cpp_signed_members = ProgramUnit.get_non_children_program_unit_members(arg_program_unit_id)
        cpp_signed_members.each do |each_required_member|
                signed_cpp_collection = CareerPathwayPlan.where("id = (select max(id) from career_pathway_plans
                                                       where career_pathway_plans.client_signature = ?
                                                      )
                                                ",each_required_member
                                                )
                if signed_cpp_collection.present?
                  latest_signed_cpp_for_program_unit_clients << signed_cpp_collection.first
                end

        end
        Rails.logger.debug("latest_signed_cpp_for_program_unit_clients - final = #{latest_signed_cpp_for_program_unit_clients.inspect}")
        return latest_signed_cpp_for_program_unit_clients
    end

    #def self.get_list_of_program_units_to_be_re_evaluated
      # A open TEA cases that are child only and minor parent
      #step1 = joins("INNER JOIN program_unit_members ON (program_unit_members.program_unit_id = program_units.id)
       #              INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
       #                                        AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID) FROM PROGRAM_UNIT_PARTICIPATIONS A WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
       #                                        AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
       #                                        )")
      #step2 = step1.where("(program_units.case_type in (6048,6049) and program_units.service_program_id = 1) or
      #step2 = step1.where("(program_units.service_program_id = 1) or
    #             (program_units.service_program_id = 4)")
    #   step3 = step2.select("distinct program_units.*")
    #   return step3
    # end

    def self.demo_test_function(arg_selected_program_unit)
        snap_program_unit_object = ""
              # step1  : create snap program unit
              # step 2 : create snap program unit members
              # step 3 : create snap program wizard object
              # step 4 : create snap program benefit members
        # find if snap program is already created for this client application id.
        snap_pgu_collection = ProgramUnit.where("client_application_id = ? and service_program_id = 17",arg_selected_program_unit.client_application_id)
        if snap_pgu_collection.blank?
              snap_program_unit_object =    ProgramUnit.new
              snap_program_unit_object.client_application_id =arg_selected_program_unit.client_application_id
              snap_program_unit_object.service_program_id = 17 # SNAP
              snap_program_unit_object.processing_location =arg_selected_program_unit.processing_location
              snap_program_unit_object.program_unit_status = arg_selected_program_unit.program_unit_status
              snap_program_unit_object.case_type  = arg_selected_program_unit.case_type if arg_selected_program_unit.case_type.present?

              snap_program_unit_object.save

             # step 2 : create snap program unit members
             tea_program_unit_members = ProgramUnitMember.where("program_unit_id = ?",arg_selected_program_unit.id)
             tea_program_unit_members.each do |each_tea_member|
                snap_program_unit_member = ProgramUnitMember.new
                snap_program_unit_member.program_unit_id = snap_program_unit_object.id
                snap_program_unit_member.client_id = each_tea_member.client_id
                snap_program_unit_member.member_status = each_tea_member.member_status
                snap_program_unit_member.member_of_application = each_tea_member.member_of_application
                snap_program_unit_member.primary_beneficiary = each_tea_member.primary_beneficiary
                snap_program_unit_member.save
             end
        else

            snap_program_unit_object = snap_pgu_collection.first


        end

         #  # step 3 : create snap program wizard object
             tea_program_wizard_object = ProgramWizard.where("program_unit_id = ?",arg_selected_program_unit.id).last
             snap_program_wizard_object = ProgramWizard.new
            snap_program_wizard_object.program_unit_id = snap_program_unit_object.id
            snap_program_wizard_object.run_id= ProgramWizard.get_program_wizard_next_run_id
            snap_program_wizard_object.month_sequence= 1
            snap_program_wizard_object.run_month = tea_program_wizard_object.run_month
            snap_program_wizard_object.no_of_months= tea_program_wizard_object.no_of_months
            snap_program_wizard_object.save

              # step 4 : create snap program benefit members
              tea_program_benefit_members_collection = ProgramBenefitMember.where("program_wizard_id = ?",tea_program_wizard_object.id)
              tea_program_benefit_members_collection.each do |each_tea_benefit_meber|
                  snap_benefit_member = ProgramBenefitMember.new
                  snap_benefit_member.program_wizard_id = snap_program_wizard_object.id
                  snap_benefit_member.client_id = each_tea_benefit_meber.client_id
                  snap_benefit_member.member_status = each_tea_benefit_meber.member_status
                  snap_benefit_member.member_sequence = each_tea_benefit_meber.member_sequence
                  snap_benefit_member.run_id = snap_program_wizard_object.run_id
                  snap_benefit_member.month_sequence =snap_program_wizard_object.month_sequence
                  snap_benefit_member.save
              end

        return snap_program_unit_object
    end


    # overwrite wizard - begin

    attr_writer :overwrite_wizard_current_step,:overwrite_wizard_process_object

    def overwrite_wizard_steps
       %w[overwrite_wizard_first overwrite_wizard_second overwrite_wizard_third overwrite_wizard_fourth overwrite_wizard_fifth overwrite_wizard_last]
    end

    def overwrite_wizard_current_step
      @overwrite_wizard_current_step || overwrite_wizard_steps.first
    end

    def overwrite_wizard_next_step
      self.overwrite_wizard_current_step = overwrite_wizard_steps[overwrite_wizard_steps.index(overwrite_wizard_current_step)+1]
    end

    def overwrite_wizard_previous_step
      self.overwrite_wizard_current_step = overwrite_wizard_steps[overwrite_wizard_steps.index(overwrite_wizard_current_step)-1]
    end

    def overwrite_wizard_first_step?
      overwrite_wizard_current_step == overwrite_wizard_steps.first
    end

    def overwrite_wizard_second_step?
      overwrite_wizard_current_step == overwrite_wizard_steps[1]
    end

    def overwrite_wizard_third_step?
      overwrite_wizard_current_step == overwrite_wizard_steps[2]
    end

    # def overwrite_wizard_fourth_step?
    #   overwrite_wizard_current_step == overwrite_wizard_steps[3]
    # end

    def overwrite_wizard_fifth_step?
      overwrite_wizard_current_step == overwrite_wizard_steps[4]
    end

    def overwrite_wizard_last_step?
      overwrite_wizard_current_step == overwrite_wizard_steps.last
    end


    def overwrite_wizard_get_process_object
      self.overwrite_wizard_process_object = overwrite_wizard_steps[overwrite_wizard_steps.index(overwrite_wizard_current_step)-1]
    end

    # overwrite wizard - end

    def self.get_open_client_program_units_for_a_given_service_program(arg_client_id, arg_service_program_id)
      # show the program ID associated with focus client.
      step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON  program_units.id =  program_unit_members.program_unit_id
                                 INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id
                               ")
      step2 = step1.where("program_unit_members.client_id =? and program_unit_participations.participation_status = 6043 and program_units.service_program_id = ?",arg_client_id, arg_service_program_id)
      step3 = step2.where("program_unit_participations.id = (select max(id) from program_unit_participations A where A.program_unit_id = program_unit_participations.program_unit_id)")
      step3.select("program_units.*").order("program_units.id DESC")
  end

  def self.update_reeval_date(program_unit_id)
      program_unit_object = ProgramUnit.find(program_unit_id)
      program_unit_object.reeval_date = Date.today
      program_unit_object.save!
  end

  def self.latest_program_unit_for_application(arg_application_id)
    where("client_application_id = ?",arg_application_id).order("id desc").first
  end


  def self.transfer_program_unit_to_different_local_office(arg_program_unit_id,arg_local_office)
    ls_msg = ""
    begin
      ActiveRecord::Base.transaction do
        #work queue finding
        pgu_object = ProgramUnit.find(arg_program_unit_id)
        if pgu_object.processing_location != arg_local_office.to_i

          ProgramUnit.events_for_program_unit_transfer(arg_program_unit_id,arg_local_office)

          work_queue_object = WorkQueue.where("reference_type = 6345 and reference_id = ?",arg_program_unit_id).first
          work_queue_object.state = 6558 #6558 eligibility determination queue
          work_queue_object.save!
          # work_queue_state_transition_object = WorkQueueStateTransition.where("work_queue_id = ?",work_queue_object.id).order("id desc")


          program_unit = ProgramUnit.find(arg_program_unit_id.to_i)
          program_unit.processing_location = arg_local_office.to_i
          program_unit.case_manager_id = nil
          program_unit.eligibility_worker_id = nil
          program_unit.save!

          program_unit_task_owners_collection = ProgramUnitTaskOwner.get_task_owners_related_to_program_unit_and_selected_ownership_type(arg_program_unit_id.to_i)
          program_unit_task_owners_collection.destroy_all

          ls_msg = "SUCCESS"
        else
          ls_msg = "Case is in the same location so transfer is not required."
        end
      end
      rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit","transfer_program_unit_to_different_local_office",err,AuditModule.get_current_user.uid)
        ls_msg = "Failed to transfer case - for more details refer to Error ID: #{error_object.id}"
    end
    return ls_msg
  end

  def self.events_for_program_unit_transfer(arg_program_unit_id,arg_local_office)
      common_action_argument_object = CommonEventManagementArgumentsStruct.new
      common_action_argument_object.event_id = 930 # Save Button
      # for task
      common_action_argument_object.program_unit_id = arg_program_unit_id
      ls_msg = EventManagementService.process_event(common_action_argument_object)
  end

#This is action is used for transfer PGU
#Vishal-03/30/2016
  def self.get_logged_in_user_active_program_units(arg_user_id,arg_household_id)
    step1 = ProgramUnit.joins("INNER JOIN client_applications ON program_units.client_application_id = client_applications.id
                                INNER JOIN households ON households.id = client_applications.household_id
                                INNER JOIN program_unit_participations ON program_units.id = program_unit_participations.program_unit_id")
    step2 = step1.where("households.id = ?
                        and (program_units.case_manager_id = ? or program_units.eligibility_worker_id = ?)
                        and program_unit_participations.participation_status = 6043
                        and  program_unit_participations.id = (select max(id)
                                                                 from program_unit_participations A
                                                                 where A.program_unit_id = program_unit_participations.program_unit_id
                                                                )
                     ",arg_household_id,arg_user_id,arg_user_id
                     )
    step3 = step2.select("program_units.*,households.name as household_name")
  end
#End -- This is action is used for transfer PRU

  def self.get_latest_program_unit_id_for_the_client(arg_client_id)
    step1 = joins("INNER JOIN program_unit_members ON program_unit_members.program_unit_id = program_units.id")
    step2 = step1.where("program_unit_members.client_id = ?", arg_client_id)
    step3 = step2.select("program_units.*").order("program_unit_members.program_unit_id DESC")
    step3.present? ? step3.first.id : nil
  end

  def self.get_open_program_unit_id_or_latest_program_unit_id_for_the_client(arg_client_id)
    program_unit_id = get_open_program_unit_for_client(arg_client_id)
    program_unit_id = get_latest_program_unit_id_for_the_client(arg_client_id) if program_unit_id.blank?
    return program_unit_id
  end

  def self.get_case_type(arg_program_unit_id)
    program_unit = find_by_id(arg_program_unit_id)
    return program_unit.present? ? program_unit.case_type : nil
  end
end

