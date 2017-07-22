class ClientAssessment < ActiveRecord::Base
	include AuditModule


 	before_create :set_create_user_fields
  	before_update :set_update_user_field

  has_many :client_assessment_answers, dependent: :destroy

	HUMANIZED_ATTRIBUTES = {
    :assessment_date => "Assessment Date",
    :comments => "Comments",
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

     validates_presence_of :assessment_date,message: "is required."

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_client_assessments(arg_client_id)
      where("client_id = ?",arg_client_id)
    end

    # def self.get_client_barriers(arg_client_id)
    #   step1 = joins("INNER JOIN assessment_barriers ON client_assessments.id = assessment_barriers.client_assessment_id
    #                  INNER JOIN barriers ON  assessment_barriers.barrier_id = barriers.id
    #                ")
    #   step2 = step1.where("client_id = ?",arg_client_id)
    #   step3 = step2.select("distinct barriers.assessment_section_id,assessment_barriers.barrier_id,barriers.description").order("barriers.assessment_section_id ASC")
    # end


     def self.get_client_employment_barriers(arg_client_id)
      step1 = joins("INNER JOIN assessment_barriers ON client_assessments.id = assessment_barriers.client_assessment_id
                     INNER JOIN barriers ON  assessment_barriers.barrier_id = barriers.id
                   ")
      step2 = step1.where("client_id = ? and barriers.assessment_section_id = 2",arg_client_id)
      step3 = step2.select("distinct client_assessments.id,barriers.assessment_section_id,assessment_barriers.barrier_id,barriers.description").order("barriers.assessment_section_id ASC")
      return step3
    end

    def self.get_client_barriers(arg_client_id)
      step1 = joins("INNER JOIN assessment_barriers ON client_assessments.id = assessment_barriers.client_assessment_id
                     INNER JOIN barriers ON  assessment_barriers.barrier_id = barriers.id
                   ")
      step2 = step1.where("client_id = ? ",arg_client_id)
      step3 = step2.select("distinct client_assessments.id,barriers.assessment_section_id,assessment_barriers.barrier_id,barriers.description").order("barriers.assessment_section_id ASC")
      return step3
    end

     def self.get_client_non_employment_barriers(arg_client_id)
      step1 = joins("INNER JOIN assessment_barriers ON client_assessments.id = assessment_barriers.client_assessment_id
                     INNER JOIN barriers ON  assessment_barriers.barrier_id = barriers.id
                   ")
      step2 = step1.where("client_id = ? and barriers.assessment_section_id != 2",arg_client_id)
      step3 = step2.select("distinct barriers.assessment_section_id,assessment_barriers.barrier_id,barriers.description").order("barriers.assessment_section_id ASC")
      return step3
    end


#start of next and previous button navigation
    attr_writer :short_assessment_current_step
    attr_accessor :selected_assessment_sections,:current_step

    # def steps
    #        %w[/14/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /ASSESSMENT/educations
    #           /12/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /13/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /ASSESSMENT/client_scores
    #           /2/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /ASSESSMENT/employments
    #           /ASSESSMENT/legal/characteristics/index
    #           /6/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /7/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /8/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize
    #           /41/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /42/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /15/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /29/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /35/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /36/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /32/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /33/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /38/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /39/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /19/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /21/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /22/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /23/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /24/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /25/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /26/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /45/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /46/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #           /ASSESSMENT/incomes
    #           /27/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    #        ]

    # end

    # Removing menus "Relationship status" "Finance" and "Final Thought" and moving "Employment" to last step
    # so the steps navigation array got commented and new one got introduced.
    # This can be reverted by reverting the rake task in sprint6 folder
    # Rake::Task["disabling_menus_realtionship_status_finance_and_final_thoughts:disable_menus"].invoke (revert the script present here)

    # /29/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
    # is replaced by /ASSESSMENT/work/characteristics/index (our client cahracteristic - general health)
    def steps
           %w[/14/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/educations
              /12/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /13/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/client_scores
              /41/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /42/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /15/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/work/characteristics/index
              /29/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/client_immunization/show
              /ASSESSMENT/disability/characteristics/index
              /ASSESSMENT/mental/characteristics/index
              /35/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/substance_abuse/characteristics/index
              /32/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/domestic/characteristics/index
              /38/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /39/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/clients/medical_pregnancy/show
              /19/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /21/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /22/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /23/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /24/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /25/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /26/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /2/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /ASSESSMENT/employments
              /ASSESSMENT/legal/characteristics/index
              /7/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
              /assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize
           ]

    end

    def self.education_steps
      %w[/14/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /ASSESSMENT/educations
          /12/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /13/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.testing_service_steps
        %w[/ASSESSMENT/client_scores]
    end

    def self.transportation_steps
      %w[/41/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /42/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.housing_steps
      %w[/15/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment]
    end

    def self.general_health_steps
      %w[/ASSESSMENT/work/characteristics/index
         /29/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
         /ASSESSMENT/client_immunization/show
         /ASSESSMENT/disability/characteristics/index
        ]
    end

    def self.mental_health_steps
      %w[/ASSESSMENT/mental/characteristics/index
         /35/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.substance_abuse_steps
      %w[/ASSESSMENT/substance_abuse/characteristics/index
         /32/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.domestic_violence_steps
      %w[/ASSESSMENT/domestic/characteristics/index
         /38/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
         /39/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.pregnancy_steps
      %w[/ASSESSMENT/clients/medical_pregnancy/show
        /19/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.child_care_steps
      %w[/21/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /22/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /23/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /24/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /25/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /26/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
        ]
    end

    def self.employment_steps
      %w[/2/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /ASSESSMENT/employments
          /ASSESSMENT/legal/characteristics/index
          /7/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment
          /assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize
        ]
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
      if @current_step.blank?
        @current_step = steps.first
      end
      current_step == steps.first
    end

    def last_step?
       if @current_step.blank?
        @current_step = steps.first
      end
      current_step == steps.last
    end

    #Short assessment steps - start


    def short_assessment_next_step(arg_next_step)
      self.current_step = arg_next_step
    end

    def short_assessment_previous_step(arg_previous_step)
      self.current_step = arg_previous_step
    end

    #short assessment steps - end

    def self.get_client_non_employment_barriers_for_action(arg_client_id)
      # Transportation challenge barrier should not be selected as action
      step1 = joins("INNER JOIN assessment_barriers ON client_assessments.id = assessment_barriers.client_assessment_id
                     INNER JOIN barriers ON  assessment_barriers.barrier_id = barriers.id
                   ")
      step2 = step1.where("client_id = ? and barriers.assessment_section_id != 2 and barriers.id != 27",arg_client_id)
      step3 = step2.select("distinct barriers.assessment_section_id,assessment_barriers.barrier_id,barriers.description").order("barriers.assessment_section_id ASC")
      return step3
    end

    def self.is_assessment_complete_for_client?(arg_client_id)
      where("client_id = ? and assessment_status = 6264",arg_client_id).count > 0
    end

    # def self.there_is_no_complete_or_withdrawn_asessment_for_client(arg_client_id)
    #   where("assessment_status in (6264,6365) and client_id = ?",arg_client_id).count == 0
    # end

    def self.get_assessment_id(arg_client_id)
      assessment_id = 0
      assessemnt_collection = where("client_id = ?",arg_client_id)
      if assessemnt_collection.present?
        assessment_id = assessemnt_collection.first.id
      end
      return assessment_id
    end


    attr_writer :interest_profiler_current_step,:interest_profiler_process_object

    def interest_profiler_steps
       %w[interest_profiler_first interest_profiler_second interest_profiler_third interest_profiler_last]
    end

    def interest_profiler_current_step
      @interest_profiler_current_step || interest_profiler_steps.first
    end

    def interest_profiler_next_step
      self.interest_profiler_current_step = interest_profiler_steps[interest_profiler_steps.index(interest_profiler_current_step)+1]
    end

    def interest_profiler_previous_step
      self.interest_profiler_current_step = interest_profiler_steps[interest_profiler_steps.index(interest_profiler_current_step)-1]
    end

    def interest_profiler_first_step?
      interest_profiler_current_step == interest_profiler_steps.first
    end

    def interest_profiler_second_step?
      interest_profiler_current_step == interest_profiler_steps[1]
    end
    def interest_profiler_third_step?
      interest_profiler_current_step == interest_profiler_steps[2]
    end

    def interest_profiler_last_step?
      interest_profiler_current_step == interest_profiler_steps.last
    end


    def interest_profiler_get_process_object
      self.interest_profiler_process_object = interest_profiler_steps[interest_profiler_steps.index(interest_profiler_current_step)-1]
    end

    # def self.create_client_assessment(arg_client_id)
    #   client_assessment_object = ClientAssessment.new
    #   client_assessment_object.client_id = arg_client_id
    #   client_assessment_object.assessment_date = Date.today
    #   client_assessment_object.assessment_status = 6265
    #   client_assessment_object.save
    #   return client_assessment_object
    # end


    def self.to_determine_next_step_functionality(arg_current_step)

        if arg_current_step.to_s == education_steps.last.to_s
          last_step_for_section = 3
        elsif arg_current_step.to_s == testing_service_steps.last.to_s
          last_step_for_section = 18
        elsif arg_current_step.to_s == transportation_steps.last.to_s
          last_step_for_section = 13
        elsif arg_current_step.to_s == housing_steps.last.to_s
          last_step_for_section = 4
        elsif arg_current_step.to_s == general_health_steps.last.to_s
          last_step_for_section = 8
        elsif arg_current_step.to_s == mental_health_steps.last.to_s
          last_step_for_section = 10
        elsif arg_current_step.to_s == substance_abuse_steps.last.to_s
          last_step_for_section = 9
        elsif arg_current_step.to_s == domestic_violence_steps.last.to_s
          last_step_for_section = 11
        elsif arg_current_step.to_s == pregnancy_steps.last.to_s
          last_step_for_section = 5
        elsif arg_current_step.to_s == child_care_steps.last.to_s
          last_step_for_section = 6
        elsif arg_current_step.to_s == employment_steps.last.to_s
          last_step_for_section = 2
        end
      return last_step_for_section
    end

    def self.to_determine_previous_step_functionality(arg_current_step)

        if arg_current_step.to_s == education_steps.first.to_s
          first_step_for_section = 3
        elsif arg_current_step.to_s == testing_service_steps.first.to_s
          first_step_for_section = 18
        elsif arg_current_step.to_s == transportation_steps.first.to_s
          first_step_for_section = 13
        elsif arg_current_step.to_s == housing_steps.first.to_s
          first_step_for_section = 4
        elsif arg_current_step.to_s == general_health_steps.first.to_s
          first_step_for_section = 8
        elsif arg_current_step.to_s == mental_health_steps.first.to_s
          first_step_for_section = 10
        elsif arg_current_step.to_s == substance_abuse_steps.first.to_s
          first_step_for_section = 9
        elsif arg_current_step.to_s == domestic_violence_steps.first.to_s
          first_step_for_section = 11
        elsif arg_current_step.to_s == pregnancy_steps.first.to_s
          first_step_for_section = 5
        elsif arg_current_step.to_s == child_care_steps.first.to_s
          first_step_for_section = 6
        elsif arg_current_step.to_s == employment_steps.first.to_s
          first_step_for_section = 2
        end
      return first_step_for_section
    end


    def self.get_next_selected_step(next_selected_section)
      case next_selected_section
      when "3"
        arg_current_step = education_steps.first
      when "18"
        arg_current_step = testing_service_steps.first
      when "13"
        arg_current_step = transportation_steps.first
      when "4"
        arg_current_step = housing_steps.first
      when "8"
        arg_current_step = general_health_steps.first
      when "10"
        arg_current_step = mental_health_steps.first
      when "9"
        arg_current_step = substance_abuse_steps.first
      when "11"
        arg_current_step = domestic_violence_steps.first
      when "5"
        arg_current_step = pregnancy_steps.first
      when "6"
        arg_current_step = child_care_steps.first
      when "2"
        arg_current_step = employment_steps.first
      end
      return arg_current_step
    end

    def self.get_previous_selected_step(previous_selected_section)
      case previous_selected_section
      when "3"
        arg_current_step = education_steps.last
      when "18"
        arg_current_step = testing_service_steps.last
      when "13"
        arg_current_step = transportation_steps.last
      when "4"
        arg_current_step = housing_steps.last
      when "8"
        arg_current_step = general_health_steps.last
      when "10"
        arg_current_step = mental_health_steps.last
      when "9"
        arg_current_step = substance_abuse_steps.last
      when "11"
        arg_current_step = domestic_violence_steps.last
      when "5"
        arg_current_step = pregnancy_steps.last
      when "6"
        arg_current_step = child_care_steps.last
      when "2"
        arg_current_step = employment_steps.last
      end
      return arg_current_step
    end

    def self.get_first_subsection_id_for_selected_section(arg_first_selected_section)

      if arg_first_selected_section == "3"
        first_sub_section_id = 14
      elsif arg_first_selected_section == "18"
        first_sub_section_id = "/ASSESSMENT/client_scores"
      elsif arg_first_selected_section == "13"
        first_sub_section_id = 41
      elsif arg_first_selected_section == "4"
        first_sub_section_id = 15
      elsif arg_first_selected_section == "8"
        first_sub_section_id = "/ASSESSMENT/work/characteristics/index"
      elsif arg_first_selected_section == "10"
        first_sub_section_id = "/ASSESSMENT/mental/characteristics/index"
      elsif arg_first_selected_section == "9"
        first_sub_section_id = "/ASSESSMENT/substance_abuse/characteristics/index"
      elsif arg_first_selected_section == "11"
        first_sub_section_id = "/ASSESSMENT/domestic/characteristics/index"
      elsif arg_first_selected_section == "5"
        first_sub_section_id = "/ASSESSMENT/clients/medical_pregnancy/show"
      elsif arg_first_selected_section == "6"
        first_sub_section_id = 21
      elsif arg_first_selected_section == "2"
        first_sub_section_id = 2
      end
      return first_sub_section_id
    end


    def self.check_if_TABE_and_LD_scores_are_present(arg_client_assessment_id,arg_program_unit_id)
      msg = "SUCCESS"
      client_assessment_object = ClientAssessment.find(arg_client_assessment_id)
      adult = Client.is_adult(client_assessment_object.client_id)
      if arg_program_unit_id.present?
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
      end
      action_plan_object = ActionPlan.where("client_id = ?",client_assessment_object.client_id).order("id  desc")
      employment_readiness_plan_object = EmploymentReadinessPlan.where("client_assessment_id = ?",client_assessment_object.id)
      tabe_score = ClientScore.check_if_TABE_scores_are_present(client_assessment_object.client_id)
      ld_score = ClientScore.check_if_LD_scores_are_present(client_assessment_object.client_id)

      if program_unit_object.present? && program_unit_object.service_program_id == 1 && adult
        if employment_readiness_plan_object.blank?
          if (tabe_score == "SUCCESS" and ld_score == "SUCCESS")
            return msg
          else
            msg = get_error_message_if_tabe_or_ld_scores_are_missing(tabe_score,ld_score)
            return msg
          end
        else
          if action_plan_object.present?
            if action_plan_object.map(&:end_date).include? nil
              return msg
            else
              latest_action_plan = ActionPlan.get_latest_action_plan(client_assessment_object.client_id)
              if (latest_action_plan.end_date > (Date.today - 6.months))
                return msg
              else
                if (tabe_score == "SUCCESS" and ld_score == "SUCCESS")
                  return msg
                else
                  msg = get_error_message_if_tabe_or_ld_scores_are_missing(tabe_score,ld_score)
                  return msg
                end
              end
            end
          else
            if (tabe_score == "SUCCESS" and ld_score == "SUCCESS")
              return msg
            else
              msg = get_error_message_if_tabe_or_ld_scores_are_missing(tabe_score,ld_score)
              return msg
            end
          end

        end
      else
        return msg
      end
    end

    def self.get_error_message_if_tabe_or_ld_scores_are_missing(arg_tabe_score,arg_ld_score)
      error_msg = ""
      if (arg_tabe_score == "FAIL" and arg_ld_score == "FAIL")
        error_msg = "Current TABE scores and LD screening are required"
      elsif (arg_tabe_score == "FAIL" and arg_ld_score == "SUCCESS")
        error_msg = "TABE scores within the last 30 days is required"
      elsif (arg_tabe_score == "SUCCESS" and arg_ld_score == "FAIL")
        error_msg = "Learning needs assessment is required"
      end
      return error_msg
    end



    def self.get_program_unit_of_plan_for_this_assessment(arg_assessment_id)
      program_unit_object = nil
      step1 = ProgramUnit.joins("INNER JOIN action_plans
                                 ON (program_units.id =  action_plans.program_unit_id
                                     and action_plans.end_date is null
                                     )
                                 INNER JOIN client_assessments
                                 ON action_plans.client_id = client_assessments.client_id")
      step2 = step1.where("client_assessments.id = ?",arg_assessment_id)

      if step2.present?

        program_unit_object = step2.first
      end
      return program_unit_object
    end





end