class ProgramWizard < ActiveRecord::Base
  has_paper_trail :class_name => 'ProgramWizardVersion',:on => [:update, :destroy]

	# Manoj Patil
	# 09/30/2014

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field
  after_save :sync_run_id_with_program_wizard_id


	has_many :program_benefit_members
  belongs_to :program_unit


  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id

  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def sync_run_id_with_program_wizard_id
    if self.id != self.run_id
      self.run_id = self.id
      self.save
    end
  end


   #Manoj 09/06/2014
  # Program Wizard- Multi step form creation of data. - start
  attr_writer :current_step,:process_object

  def steps
    # %w[program_wizard_first program_wizard_second program_wizard_third program_wizard_fourth program_wizard_fifth program_wizard_sixth program_wizard_seventh program_wizard_last]
    # %w[program_wizard_first program_wizard_second program_wizard_fourth program_wizard_fifth program_wizard_last]
    %w[program_wizard_first program_wizard_second program_wizard_last]
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


  # Program Wizard - Multi step form creation of data. - End



	def self.get_program_run_information(arg_run_id)
    where("run_id = ?", arg_run_id)
	end

	def self.create_new_program_wizard(arg_program_unit_id)
		l_object = self.new
		l_object.program_unit_id = arg_program_unit_id
		# Get the Application Date.
		l_program_unit_object = ProgramUnit.find(arg_program_unit_id)
		l_application_object = ClientApplication.find(l_program_unit_object.client_application_id)
		ldt_application_date = l_application_object.application_date
		# get default run month = application date month.
		# 01/MM/YYYY
    ldt_mm_yyyy = nil
    if ProgramUnitParticipation.is_program_unit_participation_status_open(arg_program_unit_id)

      ldt_mm_yyyy = Date.today.beginning_of_month
    else
      ldt_mm_yyyy = ldt_application_date.strftime("01/%m/%Y").to_date
    end
		l_object.run_month = ldt_mm_yyyy
    l_object.run_id = ProgramWizard.get_program_wizard_next_run_id
    l_object.month_sequence = 1

		l_object.save
		return l_object
	end

  def self.manage_program_wizard_creation(arg_program_unit_id)
    #  find Max Run ID for the program Unit
      # max_program_run_id_collection = ProgramWizard.where("program_unit_id = ? and run_id is not null",arg_program_unit_id).select("max(run_id) as max_run_id")
      program_wizard_collection = ProgramWizard.where("program_unit_id = ? and run_id is not null",arg_program_unit_id).order("run_id DESC")
      if program_wizard_collection.present?
        #  I have sorted by descending order of run id , so object will have max run id.
         max_program_run_id_object = program_wizard_collection.first
         max_run_id = max_program_run_id_object.run_id
         month_id = max_program_run_id_object.month_sequence
          # check if this Run ID is present in eligibility determination table

          # check if the result is found in one of Eligiblity determined table.
          program_month_summary_collection = ProgramMonthSummary.where("run_id = ? and month_sequence = ?", max_run_id,month_id)
          if program_month_summary_collection.present?

            # return_object = ProgramWizard.find(max_program_run_id_object.id)
            # create new Run ID.
             return_object = ProgramWizard.create_new_program_wizard(arg_program_unit_id)

          else
            # This ED run was not complete - so delete
            # delete & create
            # delete members
            ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",max_program_run_id_object.run_id,max_program_run_id_object.month_sequence).destroy_all
            ProgramMemberDetail.where("run_id = ? and month_sequence = ?",max_program_run_id_object.run_id,max_program_run_id_object.month_sequence).destroy_all
            ProgramMemberSummary.where("run_id = ? and month_sequence = ?",max_program_run_id_object.run_id,max_program_run_id_object.month_sequence).destroy_all
            ProgramMonthSummary.where("run_id = ? and month_sequence = ?",max_program_run_id_object.run_id,max_program_run_id_object.month_sequence).destroy_all
            ProgramBenefitMember.where("run_id = ? and month_sequence = ?",max_program_run_id_object.run_id,max_program_run_id_object.month_sequence).destroy_all
            # max_program_run_id_object.program_benefit_members.destroy_all

            # delete wizard
            max_program_run_id_object.destroy
            # create
             return_object = ProgramWizard.create_new_program_wizard(arg_program_unit_id)
          end
      else

          # Create New record.
           return_object = ProgramWizard.create_new_program_wizard(arg_program_unit_id)
      end

      return return_object

  end


  def self.get_program_wizard_next_run_id
    conn = ActiveRecord::Base.connection()
    return conn.select_value("SELECT nextval('program_wizard_run_id_seq')")
  end

  def self.manage_program_wizard_cancellation(arg_program_unit_id,arg_program_wizard_id)
    #  from arg_program_wizard_id get Run ID and Month_sequence.
    program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
    #  Check if Elegibility Determination process is completed?
    program_member_detail_collection = ProgramMemberDetail.where("run_id = ? and month_sequence = ?", program_wizard_object.run_id,program_wizard_object.month_sequence)
    if program_member_detail_collection.blank?
      # delete program_wizard
      # delete program_benefit_members
      program_wizard_object.program_benefit_members.destroy_all
        ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence).destroy_all
            ProgramMemberDetail.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence).destroy_all
            ProgramMemberSummary.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence).destroy_all
            ProgramMonthSummary.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence).destroy_all
      # delete wizard
      program_wizard_object.destroy
    end
  end

	def self.find_last_budget(arg_program_unit_id, arg_client_id)
		step1 = joins("INNER JOIN program_benefit_members ON program_wizards.id = program_benefit_members.program_wizard_id")
	    step2 = step1.where("program_wizards.program_unit_id = ? and program_benefit_members.client_id = ? and program_wizards.submit_date is not null", arg_program_unit_id, arg_client_id)
	    step3 = step2.select("program_wizards.run_id, program_wizards.month_sequence, program_wizards.program_unit_id,
	    					 program_benefit_members.client_id, program_benefit_members.member_sequence, program_wizards.run_month,program_wizards.run_month").order("program_wizards.run_id desc")
      if step3.present?
        step3 = step3.first
      end

      return step3
	end

  def self.get_application_id_from_program_wizard_id(arg_program_wizard_id)
    step1 = joins("INNER JOIN program_units ON program_wizards.program_unit_id = program_units.id")
    step2 = step1.where("program_wizards.id = ?", arg_program_wizard_id)
    step3 = step2.select("program_units.client_application_id")
    application_id = step3.first.client_application_id.to_i
  end


  def self.get_program_benefit_members(arg_run_id)
    benefit_member_collection = ProgramBenefitMember.where("run_id = ?",arg_run_id)
  end

  # def self.get_data_from_program_unit_id(arg_program_unit_id)
  #   where("program_unit_id = ?",arg_program_unit_id)
  # end

  def self.get_latest_run_from_program_unit_id(arg_program_unit_id)
    # where("program_unit_id = ? and submit_date is not null", arg_program_unit_id).order("submit_date DESC").last
    where("program_unit_id = ? and submit_date is not null", arg_program_unit_id).order("submit_date DESC")

  end

  def self.get_service_program_id(arg_program_wizard_id)
    program_unit_id = find(arg_program_wizard_id).program_unit_id
    service_program_id = ProgramUnit.get_service_program_id(program_unit_id)
    return service_program_id
  end

 # def self.get_sanction_to_add_sanction_for_following_month
 #    step1 = joins("inner join program_benefit_members d on program_wizards.run_id = d.run_id and program_wizards.month_sequence = d.month_sequence
 #    inner join sanctions e on e.client_id = d.client_id
 #    inner join (
 #                select program_unit_id
 #                from program_unit_participations a
 #                where a.participation_status = 6043 and
 #                      id = ( select max(id) from program_unit_participations where program_unit_id = a.program_unit_id)
 #             union
 #                select program_unit_id
 #                  from program_unit_participations a
 #                  where a.participation_status = 6044 and
 #                  (Extract(month from action_date) = Extract(month from current_date)and  Extract(year from action_date) = Extract(year from current_date)) and
 #                  id = ( select max(id) from program_unit_participations where program_unit_id = a.program_unit_id))  c
 #             on program_wizards.program_unit_id = c.program_unit_id")


 #    step2 = step1.where("program_wizards.run_id = ( select run_id
 #                       from program_wizards x
 #                       where program_wizards.program_unit_id = x.program_unit_id and x.submit_date is not null order by x.submit_date asc fetch first row only)
 #                       and ((Extract(month from e.infraction_end_date) >= Extract(month from current_date) and  Extract(year from e.infraction_end_date) = Extract(year from current_date))  or e.infraction_end_date is null)")
 #    step3 = step2.select("e.*")

 #    sanction_return = step3

 #    return sanction_return

 #    # Rails.logger.debug("-----> = #{step3.inspect}")
 #  end


  def self.update_case_type(arg_program_wizard_id)
    program_wizard_object = ProgramWizard.find(arg_program_wizard_id)

    # find the Case type for Program Wizard
    fts = FamilyTypeService.new
    family_type_struct = FamilyTypeStruct.new
    family_type_struct = fts.determine_family_type_for_program_wizard(arg_program_wizard_id)


    # update the case type
    program_wizard_object.case_type = family_type_struct.case_type_integer
    program_wizard_object.save

    # sync the program wizard case type with Program unit case type.
    program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
    program_unit_object.case_type = program_wizard_object.case_type
    program_unit_object.save


  end

  def self.get_latest_payment(arg_program_unit_id)
    where("program_unit_id = ? and submit_date is not null", arg_program_unit_id).order("id desc").first
  end

  def self.get_program_wizard_id_from_run_id(arg_run_id)
    where("run_id = ?", arg_run_id).first.id
  end

  def self.mark_this_run_id_for_planning(arg_program_wizard_id)
      # 1.program_wizards.selected_for_planning = 'Y'
      # 2.program_units.eligible_for_planning = 'Y'
      # 3.work task - to local office to assign case manager to PGU.
      # 1.
      program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
      program_wizard_object.selected_for_planning = 'Y'

      # 2.
      program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
      program_unit_object.eligible_for_planning = 'Y'

        begin
          ActiveRecord::Base.transaction do
            program_wizard_object.save!
            program_unit_object.save!
          end
          msg = "SUCCESS"
         rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizard-Model","mark_this_run_id_for_planning",err,AuditModule.get_current_user.uid)
            msg = "Failed to set eligible for planning flag - for more details refer to error ID: #{error_object.id}."
        end

  end


  def self.mark_this_run_id_for_planning_and_continue_assessment(arg_program_wizard_id)
    msg = nil
      # 1.program_wizards.selected_for_planning = 'Y'
      # 2.program_units.eligible_for_planning = 'Y'
      # 3.logged in user will become case manager
      # 4. work task assigned to case manager - reminding the case management task associated with PGU.

      program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
      program_wizard_object.selected_for_planning = 'Y'

      # 2.
      program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
      program_unit_object.eligible_for_planning = 'Y'
      # 3
      program_unit_object.case_manager_id = AuditModule.get_current_user.uid


        begin
          ActiveRecord::Base.transaction do
            program_wizard_object.save!
            program_unit_object.save!
          end
          msg = "SUCCESS"
         rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizard-Model","mark_this_run_id_for_planning_and_continue_assessment",err,AuditModule.get_current_user.uid)
            msg = "Failed when processing methods of continue assessment - for more details refer to error ID: #{error_object.id}."
        end
  end


  def self.update_selected_for_planning_flag_for_program_wizard(arg_program_wizard_id)
    # Rule: Only on program wizard of PGU will marked as selected for planning.
    # 1. update all program wizards belonging to PGU to 'N'
    program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
    ProgramWizard.where("program_unit_id = ?",program_wizard_object.program_unit_id).update_all("selected_for_planning = 'N'")
    # 2. update current wizard id as selected for planning .
    ProgramWizard.where("id = ?",arg_program_wizard_id).update_all("selected_for_planning = 'Y'")
  end


  def self.get_latest_submited_records_limit_to_2(arg_id)
      program_wizard_object = ProgramWizard.find(arg_id)
      step2 = where("id in (SELECT max(id) FROM program_wizards where program_unit_id = ? and submit_date is not null  GROUP BY date(submit_date))", program_wizard_object.program_unit_id).order("submit_date desc").limit(2)
      step3 = step2.select("*")
      return step3
  end


def self.manage_submit_payment_button(arg_program_unit_id,arg_run_date,run_month)
    result = false
    #Any retained eligibility runs that were not submitted after a submit was performed should not be allowed to be submitted.
    #The only exception is for eligibility runs performed on the same day can be submitted even if  eligibility determination was submitted on the same day.
    program_wizard_object = ProgramWizard.get_latest_payment(arg_program_unit_id)
    if program_wizard_object.present?
      selected_run =  ProgramWizard.where("program_unit_id = ? and created_at =? and run_month =? ",arg_program_unit_id,arg_run_date,run_month).first
      current_date = Date.today
      run_date = (program_wizard_object.created_at).to_date
      sumbited_date = (program_wizard_object.submit_date).to_date
        if current_date == run_date
           result = true
        elsif current_date >= run_date
            if sumbited_date.present? and selected_run.id > program_wizard_object.id
               result = true
            end
        else
          result = false
        end
    else
      result = true
    end
  return result

end


def self.get_selected_run_id_for_assessment(arg_program_unit_id)
  program_wizard_object = nil
  selected_program_wizard_collection = ProgramWizard.where("program_unit_id = ?
                                                           and selected_for_planning = 'Y'
                                                           ",arg_program_unit_id).order("updated_at DESC")
  if selected_program_wizard_collection.present?
    program_wizard_object = selected_program_wizard_collection.first
  end
  return program_wizard_object
end

def self.get_program_wizard_from_pgu_id_and_run_month(arg_program_unit_id, arg_run_month)
  where("program_unit_id = ? and run_month = ? and submit_date is not null", arg_program_unit_id,arg_run_month).order("id desc")
end

  def self.get_latest_unsubmitted_run(arg_program_unit_id)
    result = nil
    program_wizards = where("program_unit_id = ? and submit_date is null",arg_program_unit_id).order("id desc")
    result = program_wizards.first.run_id if program_wizards.present?
    return result
  end
end
