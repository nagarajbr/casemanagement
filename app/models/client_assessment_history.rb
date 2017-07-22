class ClientAssessmentHistory < ActiveRecord::Base
	include AuditModule
 	before_create :set_create_user_fields
	before_update :set_update_user_field
  after_create :update_the_client_action_plans_with_program_unit_id_if_required
  	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_client_assessment_histories(arg_client_id)
    	where("client_id = ?",arg_client_id).order("id desc")
    end

    def self.get_assessed_sections_with_barriers_from_history(arg_client_assessment_history_id)
      step1 = AssessmentSection.joins("INNER JOIN assessment_barrier_histories ON assessment_barrier_histories.assessment_section_id =  assessment_sections.id")
      step2 = step1.where("assessment_barrier_histories.client_assessment_history_id = ?",arg_client_assessment_history_id)
      step3 = step2.select("distinct assessment_sections.id,assessment_sections.title,assessment_sections.display_order").order("assessment_sections.display_order ASC")
      assessed_sections_collection = step3
      return assessed_sections_collection
    end

    def self.get_assessed_sub_sections_with_strengths_from_history(arg_client_assessment_history_id)
      step1 = AssessmentSection.joins("INNER JOIN assessment_sub_sections ON assessment_sub_sections.assessment_section_id =  assessment_sections.id
                      INNER JOIN assessment_strength_histories ON assessment_sub_sections.id =  assessment_strength_histories.assessment_sub_section_id")
      step2 = step1.where("assessment_strength_histories.client_assessment_history_id = ?",arg_client_assessment_history_id)
      step3 = step2.select("distinct assessment_sub_sections.id,assessment_sub_sections.title,
                            assessment_sub_sections.display_order").order("assessment_sub_sections.display_order ASC")
      assessed_sections_collection = step3
      return assessed_sections_collection
    end


    def self.save_client_assessment_history_tables_one_transaction(arg_client_assessment_id)
       # 1.client_assessment_history
       local_client_assessment_history_object = ClientAssessmentHistory.set_client_assessment_history_object(arg_client_assessment_id)
       # 2.client_assessment_answers_history
       client_assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ?",arg_client_assessment_id)

       # 3.assessment_barrier_history
       assessment_barriers_collection = AssessmentBarrier.where("client_assessment_id = ?",arg_client_assessment_id)

       # 4.assessment_barrier_recommendation_history
       assessment_barrier_recommendations_collection = AssessmentBarrierRecommendation.where("client_assessment_id = ?",arg_client_assessment_id)

       # 5.assessment_barrier_details_history
       # 6.assessment_strengths_history
        client_assessment_strength_collection = AssessmentStrength.get_assessment_strengths(arg_client_assessment_id)
        client_score_object = ClientScore.where("client_id = ? and test_type = 3109", ClientAssessment.find(arg_client_assessment_id).client_id).order("id DESC").first

        begin
           ActiveRecord::Base.transaction do
               # 1.client_assessment_history
              local_client_assessment_history_object.save!
                 # 2.client_assessment_answers_history
              client_assessment_answer_collection.each do |client_assessment_answer_object|
                client_assessment_answer_history_object = ClientAssessmentAnswerHistory.new
                client_assessment_answer_history_object.client_assessment_history_id = local_client_assessment_history_object.id
                client_assessment_answer_history_object.parent_primary_key_id = client_assessment_answer_object.id
                client_assessment_answer_history_object.client_assessment_id = client_assessment_answer_object.client_assessment_id
                client_assessment_answer_history_object.assessment_question_id = client_assessment_answer_object.assessment_question_id
                client_assessment_answer_history_object.answer_value = client_assessment_answer_object.answer_value
                client_assessment_answer_history_object.client_assessment_answer_created_by = client_assessment_answer_object.created_by
                client_assessment_answer_history_object.client_assessment_answer_updated_by = client_assessment_answer_object.updated_by
                client_assessment_answer_history_object.client_assessment_answer_created_at = client_assessment_answer_object.created_at
                client_assessment_answer_history_object.client_assessment_answer_updated_at = client_assessment_answer_object.updated_at
                client_assessment_answer_history_object.save!
              end # end of  client_assessment_answer_collection.each

               # 3.assessment_barrier_history
              assessment_barriers_collection.each do |assessment_barriers_object|
                assessment_barriers_history_object = AssessmentBarrierHistory.new
                assessment_barriers_history_object.client_assessment_history_id = local_client_assessment_history_object.id
                assessment_barriers_history_object.parent_primary_key_id = assessment_barriers_object.id
                assessment_barriers_history_object.client_assessment_id = assessment_barriers_object.client_assessment_id
                assessment_barriers_history_object.barrier_id = assessment_barriers_object.barrier_id
                assessment_barriers_history_object.assessment_sub_section_refers = assessment_barriers_object.assessment_sub_section_refers
                assessment_barriers_history_object.assessment_section_id = assessment_barriers_object.assessment_section_id
                assessment_barriers_history_object.client_assessment_barrier_created_by = assessment_barriers_object.created_by
                assessment_barriers_history_object.client_assessment_barrier_updated_by = assessment_barriers_object.updated_by
                assessment_barriers_history_object.client_assessment_barrier_created_at = assessment_barriers_object.created_at
                assessment_barriers_history_object.client_assessment_barrier_updated_at = assessment_barriers_object.updated_at
                assessment_barriers_history_object.save!
              end

               # 4.assessment_barrier_recommendation_history
              assessment_barrier_recommendations_collection.each do |assessment_barrier_recommendation_object|
                assessment_barrier_recommendation_history_object = AssessmentBarrierRecommendationHistory.new
                assessment_barrier_recommendation_history_object.client_assessment_history_id = local_client_assessment_history_object.id
                assessment_barrier_recommendation_history_object.parent_primary_key_id = assessment_barrier_recommendation_object.id
                assessment_barrier_recommendation_history_object.client_assessment_id = assessment_barrier_recommendation_object.client_assessment_id
                assessment_barrier_recommendation_history_object.barrier_id = assessment_barrier_recommendation_object.barrier_id
                assessment_barrier_recommendation_history_object.recommendation_id = assessment_barrier_recommendation_object.recommendation_id
                assessment_barrier_recommendation_history_object.comments = assessment_barrier_recommendation_object.comments
                assessment_barrier_recommendation_history_object.client_assessment_barrier_recommendation_created_by = assessment_barrier_recommendation_object.created_by
                assessment_barrier_recommendation_history_object.client_assessment_barrier_recommendation_updated_by = assessment_barrier_recommendation_object.updated_by
                assessment_barrier_recommendation_history_object.client_assessment_barrier_recommendation_created_at = assessment_barrier_recommendation_object.created_at
                assessment_barrier_recommendation_history_object.client_assessment_barrier_recommendation_updated_at = assessment_barrier_recommendation_object.updated_at
                assessment_barrier_recommendation_history_object.save!
              end

              # 5.assessment_barrier_details_history
              assessment_barriers_collection.each do |assessment_barrier_object|
                assessment_barrier_details_collection = AssessmentBarrierDetail.where("assessment_barrier_id = ?", assessment_barrier_object.id)
                assessment_barrier_details_collection.each do |assessment_barrier_detail_object|
                  assessment_barrier_detail_history_object = AssessmentBarrierDetailHistory.new
                  assessment_barrier_detail_history_object.client_assessment_history_id = local_client_assessment_history_object.id
                  assessment_barrier_detail_history_object.parent_primary_key_id = assessment_barrier_detail_object.id
                  assessment_barrier_detail_history_object.assessment_barrier_id = assessment_barrier_detail_object.assessment_barrier_id
                  assessment_barrier_detail_history_object.assessment_sub_section_id = assessment_barrier_detail_object.assessment_sub_section_id
                  assessment_barrier_detail_history_object.comments = assessment_barrier_detail_object.comments
                  assessment_barrier_detail_history_object.display_order = assessment_barrier_detail_object.display_order
                  assessment_barrier_detail_history_object.client_assessment_barrier_detail_created_by = assessment_barrier_detail_object.created_by
                  assessment_barrier_detail_history_object.client_assessment_barrier_detail_updated_by = assessment_barrier_detail_object.updated_by
                  assessment_barrier_detail_history_object.client_assessment_barrier_detail_created_at = assessment_barrier_detail_object.created_at
                  assessment_barrier_detail_history_object.client_assessment_barrier_detail_updated_at = assessment_barrier_detail_object.updated_at
                  assessment_barrier_detail_history_object.save!
                end # end of assessment_barrier_details_collection.each
              end # end of assessment_barriers_collection.each

                # 6.assessment_strengths_history
              if client_assessment_strength_collection.present?
                client_assessment_strength_collection.each do |each_strength_object|
                    client_assessment_strength_history_object = AssessmentStrengthHistory.new
                    client_assessment_strength_history_object.client_assessment_history_id = local_client_assessment_history_object.id
                    client_assessment_strength_history_object.parent_primary_key_id = each_strength_object.id
                    client_assessment_strength_history_object.client_assessment_id = each_strength_object.client_assessment_id
                    client_assessment_strength_history_object.assessment_sub_section_id = each_strength_object.assessment_sub_section_id
                    client_assessment_strength_history_object.comments = each_strength_object.comments
                    client_assessment_strength_history_object.display_order = each_strength_object.display_order
                    client_assessment_strength_history_object.client_assessment_strength_created_by = each_strength_object.created_by
                    client_assessment_strength_history_object.client_assessment_strength_updated_by = each_strength_object.updated_by
                    client_assessment_strength_history_object.client_assessment_strength_created_at = each_strength_object.created_at
                    client_assessment_strength_history_object.client_assessment_strength_updated_at = each_strength_object.updated_at
                    client_assessment_strength_history_object.save!
                end # end of   client_assessment_strength_collection.each
              end # end of client_assessment_strength_collection.present?

              if client_score_object.present?
                 if client_score_object.client_assessment_id == nil
                    client_score_object.client_assessment_id = local_client_assessment_history_object.id
                    client_score_object.save
                 end

              end

           end
             msg = "SUCCESS"
        rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentHistory-Model","save_client_assessment_history_tables_one_transaction",err,AuditModule.get_current_user.uid)
              msg = "Failed to complete assessment - for more details refer to error ID: #{error_object.id}."

        end

        return msg
    end

    # 1.
    def self.set_client_assessment_history_object(arg_client_assessment_id)
        client_assessment_object = ClientAssessment.find(arg_client_assessment_id)
        client_assessment_history_object = ClientAssessmentHistory.new
        client_assessment_history_object.parent_primary_key_id = client_assessment_object.id
        client_assessment_history_object.client_id = client_assessment_object.client_id
        client_assessment_history_object.assessment_date = client_assessment_object.assessment_date
        client_assessment_history_object.assessment_status = client_assessment_object.assessment_status
        client_assessment_history_object.comments = client_assessment_object.comments
        client_assessment_history_object.client_assessment_created_by = client_assessment_object.created_by
        client_assessment_history_object.client_assessment_updated_by = client_assessment_object.updated_by
        client_assessment_history_object.client_assessment_created_at = client_assessment_object.created_at
        client_assessment_history_object.client_assessment_updated_at = client_assessment_object.updated_at
        return client_assessment_history_object
    end

    def update_the_client_action_plans_with_program_unit_id_if_required
      action_plan = ActionPlan.get_action_plan_without_program_unit_id(self.client_id)
      if action_plan.present?
        program_unit_id = ProgramUnit.get_open_program_unit_id_or_latest_program_unit_id_for_the_client(self.client_id)
        if program_unit_id.present? && action_plan.program_unit_id == 0
          action_plan.program_unit_id = program_unit_id
          action_plan.save
        end
      end
    end
end


