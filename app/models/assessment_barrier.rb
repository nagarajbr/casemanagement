class AssessmentBarrier < ActiveRecord::Base
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

  #   def self.create_new_record(arg_assessment_id,arg_barrier_id,arg_comments)
  #   	assessment_barrier_object = AssessmentBarrier.new
		# assessment_barrier_object.client_assessment_id = arg_assessment_id
		# assessment_barrier_object.barrier_id = arg_barrier_id
		# assessment_barrier_object.assessment_sub_section_refers = arg_comments
		# if assessment_barrier_object.save
		# 	msg = "SUCCESS"
		# else
		# 	msg = "assessment_barrier_object.errors.full_messages.last"
		# end
		# return msg
  #   end


  #   def self.generate_barrier_recommendation(arg_assessment_id,arg_barrier_id,arg_comments,arg_sub_section_id,arg_section_id)
  #   	# Delete & Insert



  #   	# 1.assessment_barriers
  #   	# 2.assessment_barrier_details
  #   	# 3.assessment_barrier_recommendations


  #   	#1. assessment_barriers
  #   	assessment_barrier_object = AssessmentBarrier.new
		# assessment_barrier_object.client_assessment_id = arg_assessment_id
		# assessment_barrier_object.barrier_id = arg_barrier_id
		# assessment_barrier_object.assessment_section_id =arg_section_id

		# assessment_barrier_object.assessment_sub_section_refers = arg_comments
		# if assessment_barrier_object.save
		# 	msg = "SUCCESS"
		# else
		# 	msg = "assessment_barrier_object.errors.full_messages.last"
		# end

		# # 2.assessment_barrier_details
		# if msg == "SUCCESS"
		# 	# 2.assessment_barrier_details
		# 	assessment_barrier_detail_object = AssessmentBarrierDetail.new
		# 	assessment_barrier_detail_object.assessment_barrier_id = assessment_barrier_object.id
		# 	assessment_barrier_detail_object.assessment_sub_section_id = arg_sub_section_id
		# 	assessment_barrier_detail_object.display_order = 1
		# 	if assessment_barrier_detail_object.save
		# 		msg = "SUCCESS"
		# 	else
		# 		assessment_barrier_object.destroy
		# 		msg = "assessment_barrier_detail_object.errors.full_messages.last"
		# 	end
		# end

		# # 3.assessment_barrier_recommendations
		# if msg == "SUCCESS"
		# 	standard_recommendation_collection = StandardRecommendation.get_standard_recommendation_for_barrier(arg_barrier_id)
		# 	if standard_recommendation_collection.present?
		# 		assessment_barrier_recommendations_object = AssessmentBarrierRecommendation.new
		# 		assessment_barrier_recommendations_object.client_assessment_id = arg_assessment_id
		# 		assessment_barrier_recommendations_object.barrier_id = arg_barrier_id
		# 		assessment_barrier_recommendations_object.recommendation_id = standard_recommendation_collection.first.recommendation_id
		# 		if assessment_barrier_recommendations_object.save
		# 			msg = "SUCCESS"
		# 		else
		# 			msg = "assessment_barrier_recommendations_object.errors.full_messages.last"
		# 		end
		# 	end
		# end

  #   	return msg


  #   end

    def self.get_assessment_barriers(arg_assessment_id)
    	where("client_assessment_id = ?",arg_assessment_id).order("assessment_section_id,id ASC")
    end

    def self.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
    	# 1. assessment_barriers
    	assessment_barrier_collection = AssessmentBarrier.where("client_assessment_id = ? and barrier_id = ?",arg_assessment_id,arg_barrier_id)
    	if assessment_barrier_collection.present?
    		assessment_barrier_object = assessment_barrier_collection.first
    	else
    		assessment_barrier_object = AssessmentBarrier.new
    	end
		assessment_barrier_object.client_assessment_id = arg_assessment_id
		assessment_barrier_object.barrier_id = arg_barrier_id
		assessment_barrier_object.assessment_section_id = arg_section_id
		assessment_barrier_object.assessment_sub_section_refers = arg_comments
		assessment_barrier_object.save
    end

    def self.update_assessment_barrier_comments(arg_assessment_id,arg_barrier_id,arg_comments)
    	assessment_barrier_collection = AssessmentBarrier.where("client_assessment_id = ? and barrier_id = ?",arg_assessment_id,arg_barrier_id)
		if assessment_barrier_collection.present?
			assessment_barrier_object = assessment_barrier_collection.first
			assessment_barrier_object.assessment_sub_section_refers = arg_comments
			assessment_barrier_object.save
		end
    end

    def self.save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
    	# 2. assessment_barrier_recommendations
		standard_recommendation_collection = StandardRecommendation.get_standard_recommendation_for_barrier(arg_barrier_id)
		if standard_recommendation_collection.present?
			assessment_barrier_recommendations_collection = AssessmentBarrierRecommendation.where("client_assessment_id = ? and barrier_id = ?",arg_assessment_id,arg_barrier_id)
			if assessment_barrier_recommendations_collection.present?
				assessment_barrier_recommendations_object = assessment_barrier_recommendations_collection.first
			else
				assessment_barrier_recommendations_object = AssessmentBarrierRecommendation.new
			end
			assessment_barrier_recommendations_object.client_assessment_id = arg_assessment_id
			assessment_barrier_recommendations_object.barrier_id = arg_barrier_id
			assessment_barrier_recommendations_object.recommendation_id = standard_recommendation_collection.first.recommendation_id
			assessment_barrier_recommendations_object.save
		end
    end

    def self.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
    	assessment_barrier_collection = AssessmentBarrier.where("client_assessment_id = ? and barrier_id = ?",arg_assessment_id,arg_barrier_id)
    	if assessment_barrier_collection.present?
    		assessment_barrier_object = assessment_barrier_collection.first

    		assessment_barrier_detail_collection = AssessmentBarrierDetail.where("assessment_barrier_id = ? and assessment_sub_section_id = ? and comments = ? ",assessment_barrier_object.id,arg_sub_section_id,arg_comments)
			if assessment_barrier_detail_collection.present?
				assessment_barrier_detail_object = assessment_barrier_detail_collection.first
			else
				assessment_barrier_detail_object = AssessmentBarrierDetail.new
			end
			assessment_barrier_detail_object.assessment_barrier_id = assessment_barrier_object.id
			assessment_barrier_detail_object.assessment_sub_section_id = arg_sub_section_id
			assessment_barrier_detail_object.comments = arg_comments
			assessment_barrier_detail_object.display_order = arg_display_order
			assessment_barrier_detail_object.save
    	end
    end

    # def self.get_assessment_barriers_for_client(arg_client_id)
    # 	step1 = joins("INNER JOIN client_assessments ON client_assessments.id = assessment_barriers.client_assessment_id
  	#  			   	   INNER JOIN barriers ON assessment_barriers.barrier_id = barriers.id")
    # 	step2 = step1.where("client_assessments.client_id = ? and barriers.assessment_section_id = 2",arg_client_id)
    # 	step2.select("distinct assessment_barriers.barrier_id")
    # end


end
