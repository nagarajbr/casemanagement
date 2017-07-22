class EntityQuestionAnswer < ActiveRecord::Base
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


    def self.get_client_application_q_answers(arg_client_application_id)
    	where("entity_id = ?",arg_client_application_id).order("id ASC")
    end

    def self.get_answered_questions(arg_client_application_id)
    	where("entity_id = ? and answer_flag in ('1','0') ",arg_client_application_id).order("id ASC")
    end

    # def self.get_household_member_answered_questions(arg_entity_type,arg_household_member_id)
    #   where("entity_id = ? and answer_flag in ('1','0') and entity_type = ?",arg_household_member_id,arg_entity_type).order("id ASC")
    # end

    # def self.get_household_member_q_answers(arg_entity_type,arg_household_member_id)
    #   where("entity_id = ? and entity_type = ?",arg_household_member_id,arg_entity_type).order("id ASC")
    # end

    # def self.create_household_member_q_a_records(arg_household_member_id)
    #   # check if any QA present in the household?
    #     #  ALl household questions
    #     all_household_member_registration_questions = CodetableItem.where("code_table_id = 202").order("id ASC")
    #     household_member_registration = EntityQuestionAnswer.get_household_member_q_answers(6645,arg_household_member_id)
    #     if household_member_registration.blank?
    #       all_household_member_registration_questions.each do |arg_q_a|
    #         household_member_registration_q_answer_object = EntityQuestionAnswer.new
    #         household_member_registration_q_answer_object.entity_id = arg_household_member_id
    #         household_member_registration_q_answer_object.entity_type = 6645  # hh member entity
    #         household_member_registration_q_answer_object.question_category_id = 202 # hh member registration questions code table id.
    #         household_member_registration_q_answer_object.question_id = arg_q_a.id
    #         household_member_registration_q_answer_object.save
    #       end
    #     end
    # end

end
