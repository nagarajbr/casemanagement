class AssessmentBarrierRecommendationHistory < ActiveRecord::Base
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

      def self.get_history_report_detail_data(arg_client_assessment_history_id)
        step1 = joins("INNER JOIN assessment_barrier_histories ON (assessment_barrier_recommendation_histories.barrier_id = assessment_barrier_histories.barrier_id
                                                                  AND assessment_barrier_recommendation_histories.client_assessment_id = assessment_barrier_histories.client_assessment_id
                                                                  AND assessment_barrier_recommendation_histories.client_assessment_history_id = assessment_barrier_histories.client_assessment_history_id
                                                                  )
                       INNER JOIN barriers ON barriers.id = assessment_barrier_recommendation_histories.barrier_id
                       INNER JOIN recommendations ON recommendations.id = assessment_barrier_recommendation_histories.recommendation_id
                      ")
        step2 = step1.where("assessment_barrier_histories.client_assessment_history_id = ?",arg_client_assessment_history_id)
        step3 = step2.select("assessment_barrier_recommendation_histories.parent_primary_key_id,
                             assessment_barrier_recommendation_histories.barrier_id,
                             barriers.description as barrier_name,
                             assessment_barrier_recommendation_histories.recommendation_id,
                             recommendations.recommendation_text,
                             assessment_barrier_histories.assessment_section_id,
                             assessment_barrier_histories.assessment_sub_section_refers,
                             assessment_barrier_histories.parent_primary_key_id as assessment_barrier_id,
                             assessment_barrier_histories.client_assessment_history_id"
                )
        step4 = step3.order("assessment_barrier_histories.assessment_section_id,assessment_barrier_histories.barrier_id ASC")
        return step4
      end
end
