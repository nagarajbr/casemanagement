class AssessmentBarrierRecommendationCppSnapshot < ActiveRecord::Base
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

   #  def self.get_report_detail_data_from_snapshot(arg_career_pathway_plan_id)
   #      step1 = joins("INNER JOIN assessment_barrier_cpp_snapshots ON assessment_barrier_recommendation_cpp_snapshots.barrier_id = assessment_barrier_cpp_snapshots.barrier_id
   #                     INNER JOIN barriers ON barriers.id = assessment_barrier_recommendation_cpp_snapshots.barrier_id
   #                     INNER JOIN recommendations ON recommendations.id = assessment_barrier_recommendation_cpp_snapshots.recommendation_id
   #                    ")
   #      step2 = step1.where("assessment_barrier_cpp_snapshots.career_pathway_plan_id = ?",arg_career_pathway_plan_id)
   #      step3 = step2.select(" assessment_barrier_recommendation_cpp_snapshots.id,
   #                             assessment_barrier_recommendation_cpp_snapshots.barrier_id,
   #                             barriers.description as barrier_name,
   #                             assessment_barrier_recommendation_cpp_snapshots.recommendation_id,
   #                             recommendations.recommendation_text,
   #                             assessment_barrier_cpp_snapshots.assessment_section_id,
   #                             assessment_barrier_cpp_snapshots.assessment_sub_section_refers,
   #                             assessment_barrier_cpp_snapshots.id as assessment_barrier_id
   #                          "
   #                          )
   #      step4 = step3.order("assessment_barrier_cpp_snapshots.assessment_section_id,assessment_barrier_cpp_snapshots.barrier_id ASC")
   #      return step4
   #      # return_result_set_array = Array.new

   #      # step4.each do |each_record_object|
   #      #     record_hash = {}
   #      #     record_hash["BARRIER_DESCRIPTION"] = each_record_object.barrier_name
   #      #     record_hash["SUB_SECTION_NAME"] = each_record_object.sub_section_name
   #      #     record_hash["BARRIER_COMMENTS"] = each_record_object.assessment_sub_section_refers
   #      #     record_hash["RECOMMENDATION_DESCRIPTION"] = each_record_object.recommendation_text
   #      #     record_hash["RECOMMENDATION_DESCRIPTION"] = each_record_object.recommendation_text

   #      #     return_result_set_array << record_hash
   #      # end

   #      # return return_result_set_array
   # end

end



