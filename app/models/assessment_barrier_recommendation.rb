class AssessmentBarrierRecommendation < ActiveRecord::Base
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

    def self.get_assessment_barrier_recommendations(arg_assessment_id)
    	where("client_assessment_id = ?",arg_assessment_id).order("id ASC")
    end

    def self.get_report_detail_data(arg_assessment_id)
        step1 = joins("INNER JOIN assessment_barriers ON (assessment_barrier_recommendations.barrier_id = assessment_barriers.barrier_id and assessment_barrier_recommendations.client_assessment_id = assessment_barriers.client_assessment_id)
                       INNER JOIN barriers ON barriers.id = assessment_barrier_recommendations.barrier_id
                       INNER JOIN recommendations ON recommendations.id = assessment_barrier_recommendations.recommendation_id
                      ")
        step2 = step1.where("assessment_barriers.client_assessment_id = ?",arg_assessment_id)
        step3 = step2.select(" assessment_barrier_recommendations.id,
                               assessment_barrier_recommendations.barrier_id,
                               barriers.description as barrier_name,
                               assessment_barrier_recommendations.recommendation_id,
                               recommendations.recommendation_text,
                               assessment_barriers.assessment_section_id,
                               assessment_barriers.assessment_sub_section_refers,
                               assessment_barriers.id as assessment_barrier_id
                            "
                            )
        step4 = step3.order("assessment_barriers.assessment_section_id,assessment_barriers.barrier_id ASC")
        return step4

   end
end
