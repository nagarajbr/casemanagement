class ClientAssessmentAnswer < ActiveRecord::Base
has_paper_trail :class_name => 'ClntAssmntAnswerVersion',:on => [:update, :destroy]

	include AuditModule


 	before_create :set_create_user_fields
  	before_update :set_update_user_field
    after_save :set_assessment_step_as_complete

    belongs_to :client_assessment

  	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_assessment_answers_collection(arg_client_assessment_id,arg_sub_section_id)
    	where("client_assessment_id = ? and assessment_question_id in (select id from assessment_questions where assessment_sub_section_id = ?)",arg_client_assessment_id,arg_sub_section_id)
    end


     def self.challenges_in_retaining_job_collection(arg_client_assessment_id)
      result = " "
      assessment_result_for_question_12 = ""
      assessment_result_for_question_13 = ""
      assessment_result_for_question_14 = ""
      assessment_result_for_question_15 = ""
      assessment_result_for_question_4 = ""
      assessment_result_for_question_903 = ""
      answers_for_question_12 = ""
      answers_for_question_13 = ""
      answers_for_question_14 = ""
      answers_for_question_15 = ""
      answers_for_question_4 = ""
      answers_for_question_903 = ""
      assessment_answers_for_question_12 =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 12",arg_client_assessment_id)
        assessment_answers_for_question_12.each do |answer_object|
            assessment_question = AssessmentQuestion.get_title_of_question(12)
            answers_for_question_12 =  answers_for_question_12.present? ? answers_for_question_12 + ','+ answer_object.answer_value : answer_object.answer_value
            assessment_result_for_question_12 = (assessment_question + '('+ answers_for_question_12 + ')' + ',') if answers_for_question_12.present?
        end
        assessment_answers_for_question_13  =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 13",arg_client_assessment_id)
        assessment_answers_for_question_13 .each do |answer_object|
            assessment_question = AssessmentQuestion.get_title_of_question(13)
            answers_for_question_13 =  answers_for_question_13.present? ? answers_for_question_13 + ','+ answer_object.answer_value : answer_object.answer_value
            assessment_result_for_question_13 = (assessment_question + '('+ answers_for_question_13 + ')' + ',' ) if answers_for_question_13.present?
        end
        assessment_question_14 =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 14",arg_client_assessment_id)
        assessment_question_14.each do |answer_object|
            assessment_question = AssessmentQuestion.get_title_of_question(14)
            answers_for_question_14 =  answers_for_question_14.present? ? answers_for_question_14 + ','+ answer_object.answer_value : answer_object.answer_value
            assessment_result_for_question_14 = (assessment_question + '('+ answers_for_question_14 + ')' + ',') if answers_for_question_14.present?
        end
        assessment_question_15 =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 15",arg_client_assessment_id)
        assessment_question_15.each do |answer_object|
            assessment_question = AssessmentQuestion.get_title_of_question(15)
            answers_for_question_15 =  answers_for_question_15.present? ? answers_for_question_15 + ','+ answer_object.answer_value : answer_object.answer_value
            assessment_result_for_question_15 = (assessment_question + '('+ answers_for_question_15 + ')' + ',') if answers_for_question_15.present?
        end
        assessment_question_4 =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 4",arg_client_assessment_id)
        assessment_question_4.each do |answer_object|
            assessment_question = AssessmentQuestion.get_title_of_question(4)
            answers_for_question_4 =  answers_for_question_4.present? ? answers_for_question_4 + ','+ answer_object.answer_value : answer_object.answer_value
            assessment_result_for_question_4 = (assessment_question + '('+ answers_for_question_4 + ')' + ',') if answers_for_question_4.present?
        end
        assessment_question_903 =  ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 903",arg_client_assessment_id)
        assessment_question_903.each do |answer_object|
        unless answer_object.answer_value == '0'
          assessment_question = AssessmentQuestion.get_title_of_question(903)
          answers_for_question_903 = answers_for_question_903.present? ? answers_for_question_903 + ','+ answer_object.answer_value : answer_object.answer_value
          assessment_result_for_question_903 = (assessment_question + '('+ answers_for_question_903 + ')' + ',') if answers_for_question_903.present?
        end
      end
      result = assessment_result_for_question_12 + assessment_result_for_question_13 + assessment_result_for_question_14 + assessment_result_for_question_15 + assessment_result_for_question_4 + assessment_result_for_question_903
      return result
    end

    def self.get_answer_collection(arg_assessment_id,arg_qstn_id)
      where("client_assessment_id = ? and assessment_question_id = ?",arg_assessment_id,arg_qstn_id)
    end

    def self.get_answer_collection_for_question_value(arg_assessment_id,arg_qstn_id,arg_value)
      ans_checked_collection = where("client_assessment_id = ? and assessment_question_id = ? and answer_value=?",arg_assessment_id,arg_qstn_id,arg_value)
      if ans_checked_collection.present?
        return true
      else
         return false
      end
    end

    def self.get_answers_collection_for_assessment(arg_assessment_id)
      where("client_assessment_id = ?",arg_assessment_id).order("id ASC")
    end

    def self.does_this_client_need_tea_diversion_based_on_assessment?(arg_client_id)
      # Manoj 02/03/2016
      # Rule:
      # 1. Client should be currently working OR should have job offer to work in a month or next month
      # 2. should answer factors why he needs help - health,household,child care, housing/transportation
      # 3. should request for financial assitance to solve crisis
      # # questions
      # # Question ID | desription
      # 2;"Are you currently working?"
      # 3;;"(If not currently working) <br> Do you have job offer to start working within a month or next month?"
      # 12;;"Health"
      # 13;;"Household"
      # 14;;"Childcare"
      # 15;;"Housing / Transportation"
      # 4;2;"Other reasons, please explain"
      # 903;;"Could a one-time benefit payment get you through so that you are able to take care of yourself and your family?"


       # Rule1 : Client should be currently working OR should have job offer to work in a month or next month
        step1 = ClientAssessmentAnswer.joins(" INNER JOIN client_assessments
                                               ON client_assessment_answers.client_assessment_id = client_assessments.id")
        step2 = step1.where("client_assessments.client_id = ?
                             AND
                             (client_assessment_answers.assessment_question_id = 2 and client_assessment_answers.answer_value = 'Y'
                              OR
                             client_assessment_answers.assessment_question_id = 3 and client_assessment_answers.answer_value = 'Y'
                             )
                             ",arg_client_id)
        if step2.present?
            # Rule 2:should request for financial assitance to solve crisis
            step3 = step1.where(" client_assessments.client_id = ?
                                AND
                                client_assessment_answers.assessment_question_id = 903
                                and  CAST(coalesce(client_assessment_answers.answer_value,'0') AS INTEGER) between 0 and 901
                                ",arg_client_id
                                )
            if step3.present?
                # Rule 3:should answer factors why he needs help - health,household,child care, housing/transportation
                step4 = step1.where(" client_assessments.client_id = ?
                                      AND
                                      ( assessment_question_id in (4,12,13,14,15)
                                        and answer_value in ('No permanent housing','Vehicle needs repair','No transportation','Can not find childcare',
                                                             'Issue with household member','Issue with child','Mental health/stress','Physical health'
                                                            )
                                      )
                                    ",arg_client_id
                                  )
                if step4.present?
                  return true
                else
                  return false
                end
            else
              return false
            end
        else
          return false
        end

    end


    def self.did_user_answer_any_employment_assessment_questions?(arg_client_id)
          step1 = ClientAssessmentAnswer.joins(" INNER JOIN client_assessments
                                               ON client_assessment_answers.client_assessment_id = client_assessments.id")
          step2 = step1.where(" client_assessments.client_id = ?
                                      AND
                                      (
                                         client_assessment_answers.assessment_question_id = 4 and client_assessment_answers.answer_value IS NOT NULL
                                         OR
                                          client_assessment_answers.assessment_question_id = 12 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 13 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 14 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 15 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 903  and  CAST(coalesce(client_assessment_answers.answer_value,'0') AS INTEGER) > 0
                                          OR
                                          client_assessment_answers.assessment_question_id = 6 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 7 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 8 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 9 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 10 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 11 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 89 and client_assessment_answers.answer_value IS NOT NULL
                                          OR
                                          client_assessment_answers.assessment_question_id = 495 and client_assessment_answers.answer_value IS NOT NULL
                                      )
                                    ",arg_client_id
                                  )
        if step2.present?
          return true
        else
          return false
        end
    end


    def set_assessment_step_as_complete
      # get assessment ID
      lb_any_question_answered = false

      client_assessment = ClientAssessment.find(self.client_assessment_id)
      # if ClientAssessmentAnswer.did_user_answer_any_employment_assessment_questions?(client_assessment.client_id) == true
        employment_assessment_questions = [4,12,13,14,15,6,7,8,9,10,11,89,495]
        employment_assessment_questions.each do |each_question|
          if self.assessment_question_id == each_question && self.answer_value.present?
             lb_any_question_answered = true
             break
          end
        end
        if self.assessment_question_id == 903 && self.answer_value.present?
            if self.answer_value.to_i > 0
              lb_any_question_answered = true
            end
        end

        if lb_any_question_answered == true
          HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(client_assessment.client_id,'household_member_assessment_employment_step','Y')
        end


    end

    def self.populate_assessment_and_assessment_answer_from_employment_step(arg_client_id)
       client_object = Client.find(arg_client_id)
      assessment_collection = ClientAssessment.where("client_id = ?",arg_client_id)
      if assessment_collection.present?
        client_assessment_object = assessment_collection.first
      else
        client_assessment_object = ClientAssessment.new
      end
      client_assessment_object.client_id = arg_client_id
      client_assessment_object.assessment_date = Date.today
      client_assessment_object.assessment_status = 6265 # incomplete
      client_assessment_object.save

      # Assessment answer for are you currently working
      assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",client_assessment_object.id)
      if assessment_answer_collection.present?
        client_assessment_answer_object = assessment_answer_collection.first
      else
        client_assessment_answer_object = ClientAssessmentAnswer.new
      end

      client_assessment_answer_object.client_assessment_id = client_assessment_object.id
      client_assessment_answer_object.assessment_question_id = 2 # are you currently working
      if client_object.currently_working_flag == 'Y'
        client_assessment_answer_object.answer_value = 'Y'
      else
        client_assessment_answer_object.answer_value = 'N'
      end
      client_assessment_answer_object.save

      # Assessment answer for job offer_flag
      assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 3",client_assessment_object.id)
      if assessment_answer_collection.present?
        client_assessment_answer_object = assessment_answer_collection.first
      else
        client_assessment_answer_object = ClientAssessmentAnswer.new
      end
      client_assessment_answer_object.client_assessment_id = client_assessment_object.id
      client_assessment_answer_object.assessment_question_id = 3 #
      if client_object.job_offer_flag == 'Y'
        client_assessment_answer_object.answer_value = 'Y'
      else
        client_assessment_answer_object.answer_value = 'N'
      end
      client_assessment_answer_object.save
    end


end
