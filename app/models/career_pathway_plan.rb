class CareerPathwayPlan < ActiveRecord::Base

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field


	   HUMANIZED_ATTRIBUTES = {
        update_communication_type: "Communication Type",
        case_worker_signature: "Case Worker",
        case_worker_signed_date: "Case Worker Review Date",
        supervisor_signature: "Supervisor",
        supervisor_signed_date: "Supervisor Review Date",
        client_signature: "Client Signature",
        client_signed_date: "Client Signed Date"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_presence_of :case_worker_signed_date, :update_communication_type,:client_signed_date,message: "is required."
    validate :valid_case_worker_signed_date?, :valid_client_signed_date?
    validates_presence_of :reason, :on => :update, :if => lambda{state.to_i == 6167}, message: "is required."


    # State machine state management start Manoj 07/17/2015
	state_machine :state, :initial => :complete do
	    audit_trail context: [:created_by, :reason]
	     # audit_trail context: :created_by

	    state :complete, value: 6165
	    state :requested, value: 6373
	    state :rejected, value: 6167
	    state :approved, value: 6166

	    event :request do
	          transition :complete => :requested
	    end

	    event :approve do
	        transition :requested => :approved
	    end

	    event :reject do
	    	transition :requested => :rejected
	    end

	    event :re_request do
	    	transition :rejected => :requested
	    end

	end
  # State machine state management end Manoj 07/17/2015

    def created_by
	    # updated user id
	    AuditModule.get_current_user.uid
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

	def valid_case_worker_signed_date?
		if case_worker_signed_date.present?
		  if  case_worker_signed_date < Date.civil(1900, 1, 1)
		       errors[:base] << "Case worker review date must be after 01/01/1900."
		    return false
		  elsif case_worker_signed_date > Date.today
			errors[:base] << "Case worker review date cannot be future date."
		    return false
		  else
		    return true
		  end
		else
			return false
		end
	end

	def valid_client_signed_date?
		if client_signed_date.present?
		  if  client_signed_date < Date.civil(1900, 1, 1)
		       errors[:base] << "Client signed date must be after 01/01/1900."
		    return false
		  elsif client_signed_date > Date.today
			errors[:base] << "Client signed date cannot be future date."
		    return false
		  else
		    return true
		  end
		else
			return false
		end
	end

    # def self.get_pending_cpp_plan(arg_client_id)
    # 	return_cpp_collection = CareerPathwayPlan.where("1=2")
    # 	# get Assessment for the passed client_id
    # 	client_assessment_collection = ClientAssessment.where("client_id = ?",arg_client_id)
    # 	if client_assessment_collection.present?
    # 		client_assessment_object = client_assessment_collection.first
    # 		# get pending cpp for the assessment id.
    # 		return_cpp_collection = CareerPathwayPlan.where("client_assessment_id = ? and client_signed_date is null",client_assessment_object.id)
    # 	end

    # 	return return_cpp_collection
    # end

    def self.get_approved_cpp_plan_list_for_selected_client(arg_client_id)
    	# Manoj 04/15/2016 - commented showing only latest approved CPP - instead show all approved CPP.
    	# comment start
    	#state - 6166 - approved
    	# step1 = joins("INNER JOIN program_units ON program_units.id = career_pathway_plans.program_unit_id")
    	# step2 = step1.where("career_pathway_plans.client_signature = ? and career_pathway_plans.state = 6166",arg_client_id)
    	# step3 = step2.select("career_pathway_plans.*,program_units.service_program_id").order("id desc").limit(1)
    	# return step3
    	# comment end
    	step1 = joins("INNER JOIN program_units ON program_units.id = career_pathway_plans.program_unit_id")
    	step2 = step1.where("career_pathway_plans.client_signature = ? and career_pathway_plans.state = 6166",arg_client_id)
    	step3 = step2.select("career_pathway_plans.*,program_units.service_program_id").order("id desc")
    	return step3
    end

    def self.get_not_approved_cpp_plan_list_for_selected_client(arg_client_id)
    	#state - 6166 - approved
    	step1 = joins("INNER JOIN program_units ON program_units.id = career_pathway_plans.program_unit_id")
    	step2 = step1.where("career_pathway_plans.client_signature = ? and career_pathway_plans.state != 6166",arg_client_id)
    	step3 = step2.select("career_pathway_plans.*,program_units.service_program_id").order("id desc")
    	return step3
    end


     # 1.set_client_assessment_cpp_snapshot_data
    def self.set_client_assessment_cpp_snapshot_data(arg_assessment_id)
	    	client_assessment_object=ClientAssessment.find(arg_assessment_id)
	    	client_assessment_cpp_snapshot_object = ClientAssessmentCppSnapshot.new
	    	# client_assessment_cpp_snapshot_object.attributes = client_assessment_object.attributes

	    	client_assessment_cpp_snapshot_object.client_assessment_id = client_assessment_object.id
	    	client_assessment_cpp_snapshot_object.client_id = client_assessment_object.client_id
	    	client_assessment_cpp_snapshot_object.assessment_date =  client_assessment_object.assessment_date
	    	client_assessment_cpp_snapshot_object.assessment_status = client_assessment_object.assessment_status
	    	client_assessment_cpp_snapshot_object.comments = client_assessment_object.comments
	    	client_assessment_cpp_snapshot_object.client_assessment_created_by = client_assessment_object.created_by
	    	client_assessment_cpp_snapshot_object.client_assessment_updated_by = client_assessment_object.updated_by
	    	client_assessment_cpp_snapshot_object.client_assessment_created_at = client_assessment_object.created_at
	    	client_assessment_cpp_snapshot_object.client_assessment_updated_at = client_assessment_object.updated_at
	    	client_assessment_cpp_snapshot_object.parent_primary_key_id = client_assessment_object.id
	    	return client_assessment_cpp_snapshot_object
    end

    # 2.
   #   def self.set_client_employment_readiness_plan_cpp_snapshot_object(arg_assessment_id)
   #   		employment_readiness_plan_object=EmploymentReadinessPlan.where("client_assessment_id = ?",arg_assessment_id).first
	  #   	employment_readiness_plan_cpp_snapshot_object = EmploymentReadinessPlanCppSnapshot.new
	  #   	#employment_readiness_plan_cpp_snapshot_object.career_pathway_plan_id = arg_cpp_object.id
	  #   	employment_readiness_plan_cpp_snapshot_object.client_assessment_id = employment_readiness_plan_object.id
	  #   	employment_readiness_plan_cpp_snapshot_object.core_hours = employment_readiness_plan_object.core_hours
	  #   	employment_readiness_plan_cpp_snapshot_object.non_core_hours =  employment_readiness_plan_object.non_core_hours
	  #   	employment_readiness_plan_cpp_snapshot_object.supportive_services_hours = employment_readiness_plan_object.supportive_services_hours
	  #   	employment_readiness_plan_cpp_snapshot_object.other_hours = employment_readiness_plan_object.other_hours
	  #   	employment_readiness_plan_cpp_snapshot_object.comments = employment_readiness_plan_object.comments
	  #   	employment_readiness_plan_cpp_snapshot_object.employment_readiness_plan_created_by = employment_readiness_plan_object.created_by
	  #   	employment_readiness_plan_cpp_snapshot_object.employment_readiness_plan_updated_by = employment_readiness_plan_object.updated_by
	  #   	employment_readiness_plan_cpp_snapshot_object.employment_readiness_plan_created_at = employment_readiness_plan_object.created_at
	  #   	employment_readiness_plan_cpp_snapshot_object.employment_readiness_plan_updated_at = employment_readiness_plan_object.updated_at
	  #   	employment_readiness_plan_cpp_snapshot_object.parent_primary_key_id = employment_readiness_plan_object.id
			# return  employment_readiness_plan_cpp_snapshot_object

   #  end



    def self.create_client_signed_cpp_snapshot_in_one_transaction(arg_client_id,arg_assessment_id,arg_cpp_object)
    	# msg = "SUCCESS"
    	# 1.career_pathway_plans
    	cpp_object = arg_cpp_object
    	# 1.5
    	# employment_readiness_plan_object =EmploymentReadinessPlan.get_employment_readiness_pan(arg_assessment_id)
    	# employment_readiness_plan_object.core_hours = cpp_object.core_hours
    	# employment_readiness_plan_object.non_core_hours = cpp_object.non_core_hours

    	# 2.action_plans,action_plan_details,service_authorizations - client agreement date
    	@action_plan_collection = ActionPlan.where("employment_readiness_plan_id =?",arg_cpp_object.employment_readyness_plan_id)

    	# 3.client_assessments_CPP_SNAPSHOT
    	client_assessment_cpp_snapshot_object = CareerPathwayPlan.set_client_assessment_cpp_snapshot_data(arg_assessment_id)
    	# 4.client_assessment_answers_cpp_snapshots
    	client_assessment_answer_collection = ClientAssessmentAnswer.get_answers_collection_for_assessment(arg_assessment_id)
    	# 5.assessment_barriers_CPP_SNAPSHOT
    	client_assessment_barrier_collection = AssessmentBarrier.get_assessment_barriers(arg_assessment_id)
    	# 6.assessment_barrier_details_CPP_SNAPSHOT
    	client_assessment_barrier_detail_collection = AssessmentBarrierDetail.get_assessment_barrier_details(arg_assessment_id)
    	# 7. assessment_barrier_recommendation_cpp_snapshots
    	client_assessment_barrier_recommendation_collection = AssessmentBarrierRecommendation.get_assessment_barrier_recommendations(arg_assessment_id)
		#  8. assessment_strengths_cpp_snapshots
		client_assessment_strength_collection = AssessmentStrength.get_assessment_strengths(arg_assessment_id)
		# 9.employment_readiness_plan_cpp_snapshots
		# client_employment_readiness_plan_cpp_snapshot_object = CareerPathwayPlan.set_client_employment_readiness_plan_cpp_snapshot_object(arg_assessment_id)
		# 10.
		# l_employment_readiness_plan_id = EmploymentReadinessPlan.where("client_assessment_id = ?",arg_assessment_id).first.id
		client_action_plan_collections = ActionPlan.where("client_id = ? and action_plan_status = 6043",arg_client_id).order("id ASC")

		# 11.action_plan_detail_cpp_snapshots
		step1 = ActionPlanDetail.joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                        INNER JOIN client_assessments ON client_assessments.client_id = action_plans.client_id
    		                          ")
    	step2 = step1.where("client_assessments.id = ? and action_plans.action_plan_status = 6043 and action_plan_details.activity_status = 6043",arg_assessment_id)
    	step3 = step2.order("action_plan_id,id ASC")
    	client_action_plan_details_collections = step3

    	# 12.schedule_cpp_snapshots
    	step1 = Schedule.joins("INNER JOIN action_plan_details ON action_plan_details.id = schedules.reference_id
    		                    INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                INNER JOIN client_assessments ON client_assessments.client_id = action_plans.client_id
    		                    ")
    	step2 = step1.where("client_assessments.id = ? and action_plans.action_plan_status = 6043 and action_plan_details.activity_status = 6043",arg_assessment_id)
    	step3 = step2.select("distinct schedules.*")
    	step4 = step3.order("schedules.reference_id,schedules.id ASC")
    	client_action_plan_details_schedule_collections=step4

    	# 13. service_authorization_cpp_snapshots
    	step1 = ServiceAuthorization.joins(" INNER JOIN action_plan_details ON action_plan_details.id = service_authorizations.action_plan_detail_id
    		                                 INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                             INNER JOIN client_assessments ON client_assessments.client_id = action_plans.client_id
    		                          ")
    	step2 = step1.where("client_assessments.id = ? and action_plans.action_plan_status = 6043 and action_plan_details.activity_status = 6043",arg_assessment_id)
    	step3 = step2.order("id ASC")
    	client_service_authorization_collection = step3

    	begin
            ActiveRecord::Base.transaction do
            	# 1.career_pathway_plans
            	cpp_object.save!
            	# 1.5
            	# employment_readiness_plan_object.save!
            	# 2.action_plans
            	# @action_plan_collection.each do |action_plan|
            	client_action_plan_collections.each do |action_plan|
					action_plan.client_agreement_date = arg_cpp_object.client_signed_date
					action_plan.save!
						# 3.action_plan_details
    					# @action_plan_details_collection = ActionPlanDetail.where("action_plan_id =?",action_plan.id)
    					@action_plan_details_collection = ActionPlanDetail.where("action_plan_id =? and activity_status = 6043",action_plan.id)
						# 3.action_plan_details
						if @action_plan_details_collection.present?
							@action_plan_details_collection.each do |action_plan_detail|
								action_plan_detail.client_agreement_date = arg_cpp_object.client_signed_date
								action_plan_detail.save!
								# 4.service_authorizations
								@service_authorization_collection = ServiceAuthorization.where("action_plan_detail_id = ?",action_plan_detail.id)
								if @service_authorization_collection.present?
									@service_authorization_collection.each do |service_authorization|
										service_authorization.client_agreement_date = arg_cpp_object.client_signed_date
										service_authorization.status = 6162 # Authorized
										service_authorization.save!
									end # end of @service_authorization_collection
								end # end of if @service_authorization_collection.present
							end # end of @action_plan_details_collection
						end # end of 	if @action_plan_details_collection.present?
				end # end of @action_plan_collection

				# 3.client_assessments_CPP_SNAPSHOT
				client_assessment_cpp_snapshot_object.career_pathway_plan_id = cpp_object.id
				client_assessment_cpp_snapshot_object.save!

				# 4.client_assessment_answers_cpp_snapshots
				client_assessment_answer_collection.each do |each_answer_object|
					answer_cpp_object = CareerPathwayPlan.client_assessment_answers_cpp_snapshot_each_record(each_answer_object.id,cpp_object.id)
					answer_cpp_object.save!
				end
				# 5.assessment_barriers_CPP_SNAPSHOT
				client_assessment_barrier_collection.each do |each_barrier_object|
					barrier_cpp_object = CareerPathwayPlan.client_assessment_barrier_cpp_snapshot_each_record(each_barrier_object.id,cpp_object.id)
					barrier_cpp_object.save!
				end

				# 6.assessment_barrier_details_CPP_SNAPSHOT
				client_assessment_barrier_detail_collection.each do |each_barrier_detail_object|
					barrier_detail_cpp_object = CareerPathwayPlan.client_assessment_barrier_detail_cpp_snapshot_each_record(arg_assessment_id,each_barrier_detail_object.id,cpp_object.id)
					barrier_detail_cpp_object.save!
				end

				# 7. assessment_barrier_recommendation_cpp_snapshots
				if client_assessment_barrier_recommendation_collection.present?
					client_assessment_barrier_recommendation_collection.each do |each_barrier_recommendation_object|
						barrier_recommendation_cpp_object = CareerPathwayPlan.client_assessment_barrier_recommendation_cpp_snapshot_each_record(each_barrier_recommendation_object.id,cpp_object.id)
						barrier_recommendation_cpp_object.save!
					end
				end

				# 8. assessment_strengths_cpp_snapshots
				if client_assessment_strength_collection.present?
					client_assessment_strength_collection.each do |each_strength_object|
						strength_cpp_object = CareerPathwayPlan.client_assessment_strength_cpp_snapshot_each_record(each_strength_object.id,cpp_object.id)
						strength_cpp_object.save!
					end
				end

				# 9.employment_readiness_plan_cpp_snapshots
				# client_employment_readiness_plan_cpp_snapshot_object.career_pathway_plan_id = cpp_object.id
				# client_employment_readiness_plan_cpp_snapshot_object.save!

				# 10. action_plan_cpp_snapshots
				client_action_plan_collections.each do |each_action_plan_object|
					action_plan_cpp_object = CareerPathwayPlan.client_assessment_action_plan_cpp_snapshot_each_record(each_action_plan_object.id,cpp_object.id)
					action_plan_cpp_object.save!
				end

				# 11.action_plan_detail_cpp_snapshots
				client_action_plan_details_collections.each do |each_action_plan_detail_object|
					action_plan_detail_cpp_object = CareerPathwayPlan.client_assessment_action_plan_details_cpp_snapshot_each_record(each_action_plan_detail_object.id,cpp_object.id)
					action_plan_detail_cpp_object.save!
				end

				# 12.schedule_cpp_snapshots
				client_action_plan_details_schedule_collections.each do |each_action_plan_detail_schedule_object|
					action_plan_detail_schedule_cpp_object = CareerPathwayPlan.client_action_plan_detail_schedule_cpp_snapshot_each_record(each_action_plan_detail_schedule_object.id,cpp_object.id)
			 		action_plan_detail_schedule_cpp_object.save!
			 	end

			 	# 13. service_authorization_cpp_snapshots
			 	client_service_authorization_collection.each do |each_client_service_authorization|
		    		service_authorization_cpp_object = CareerPathwayPlan.client_assessment_service_authorization_cpp_snapshot_each_record(each_client_service_authorization.id,arg_cpp_object.id)
		    		service_authorization_cpp_object.save!
		    	end

		     end # end of ActiveRecord::Base.transaction
		     msg = "SUCCESS"
	    rescue => err
	    	error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlan-Model","create_client_signed_cpp_snapshot_in_one_transaction",err,AuditModule.get_current_user.uid)
	    	msg = "Failed to create career plan - for more details refer to error ID: #{error_object.id}."
        end
        return msg

    end




	# 2.1  client_assessment_answers_CPP_SNAPSHOT
    def self.client_assessment_answers_cpp_snapshot_each_record(arg_client_assessment_answer_id,arg_career_pathway_plan_id)

    	client_assessment_answer_object=ClientAssessmentAnswer.find(arg_client_assessment_answer_id)
    	client_assessment_answer_cpp_snapshot_object = ClientAssessmentAnswersCppSnapshot.new
    	client_assessment_answer_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_assessment_answer_cpp_snapshot_object.client_assessment_id = client_assessment_answer_object.client_assessment_id
    	client_assessment_answer_cpp_snapshot_object.assessment_question_id = client_assessment_answer_object.assessment_question_id
    	client_assessment_answer_cpp_snapshot_object.answer_value = client_assessment_answer_object.answer_value
    	client_assessment_answer_cpp_snapshot_object.client_assessment_answer_created_by = client_assessment_answer_object.created_by
    	client_assessment_answer_cpp_snapshot_object.client_assessment_answer_updated_by = client_assessment_answer_object.updated_by
    	client_assessment_answer_cpp_snapshot_object.client_assessment_answer_created_at = client_assessment_answer_object.created_at
    	client_assessment_answer_cpp_snapshot_object.client_assessment_answer_updated_at = client_assessment_answer_object.updated_at
    	client_assessment_answer_cpp_snapshot_object.parent_primary_key_id = client_assessment_answer_object.id
    	return client_assessment_answer_cpp_snapshot_object
    end



  # 3.1 assessment_barriers_CPP_SNAPSHOT
  def self.client_assessment_barrier_cpp_snapshot_each_record(arg_assessment_barrier_id,arg_career_pathway_plan_id)
    	client_assessment_barrier_object=AssessmentBarrier.find(arg_assessment_barrier_id)
    	client_assessment_barrier_cpp_snapshot_object = AssessmentBarrierCppSnapshot.new
    	client_assessment_barrier_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_assessment_barrier_cpp_snapshot_object.client_assessment_id = client_assessment_barrier_object.client_assessment_id
    	client_assessment_barrier_cpp_snapshot_object.barrier_id = client_assessment_barrier_object.barrier_id
    	client_assessment_barrier_cpp_snapshot_object.assessment_section_id = client_assessment_barrier_object.assessment_section_id
    	client_assessment_barrier_cpp_snapshot_object.assessment_sub_section_refers = client_assessment_barrier_object.assessment_sub_section_refers
    	client_assessment_barrier_cpp_snapshot_object.assessment_barrier_created_by = client_assessment_barrier_object.created_by
    	client_assessment_barrier_cpp_snapshot_object.assessment_barrier_updated_by = client_assessment_barrier_object.updated_by
    	client_assessment_barrier_cpp_snapshot_object.assessment_barrier_created_at = client_assessment_barrier_object.created_at
    	client_assessment_barrier_cpp_snapshot_object.assessment_barrier_updated_at = client_assessment_barrier_object.updated_at
    	client_assessment_barrier_cpp_snapshot_object.parent_primary_key_id = client_assessment_barrier_object.id
    	return client_assessment_barrier_cpp_snapshot_object
    end




     # 4.1 assessment_barrier_details_CPP_SNAPSHOT
     def self.client_assessment_barrier_detail_cpp_snapshot_each_record(arg_assessment_id,arg_assessment_barrier_detail_id,arg_career_pathway_plan_id)
    	client_assessment_barrier_detail_object=AssessmentBarrierDetail.find(arg_assessment_barrier_detail_id)
    	client_assessment_barrier_detail_cpp_snapshot_object = AssessmentBarrierDetailsCppSnapshot.new
    	client_assessment_barrier_detail_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_assessment_barrier_detail_cpp_snapshot_object.client_assessment_id = arg_assessment_id
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_barrier_id = client_assessment_barrier_detail_object.assessment_barrier_id
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_sub_section_id = client_assessment_barrier_detail_object.assessment_sub_section_id
    	client_assessment_barrier_detail_cpp_snapshot_object.comments = client_assessment_barrier_detail_object.comments
    	client_assessment_barrier_detail_cpp_snapshot_object.display_order = client_assessment_barrier_detail_object.display_order
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_barrier_detail_created_by = client_assessment_barrier_detail_object.created_by
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_barrier_detail_updated_by = client_assessment_barrier_detail_object.updated_by
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_barrier_detail_created_at = client_assessment_barrier_detail_object.created_at
    	client_assessment_barrier_detail_cpp_snapshot_object.assessment_barrier_detail_updated_at = client_assessment_barrier_detail_object.updated_at
    	client_assessment_barrier_detail_cpp_snapshot_object.parent_primary_key_id = client_assessment_barrier_detail_object.id
    	return client_assessment_barrier_detail_cpp_snapshot_object
    end




    # 5.1assessment_barrier_recommendations_CPP_SNAPSHOT
     def self.client_assessment_barrier_recommendation_cpp_snapshot_each_record(arg_assessment_barrier_recommendation_id,arg_career_pathway_plan_id)
    	client_assessment_barrier_recommendation_object=AssessmentBarrierRecommendation.find(arg_assessment_barrier_recommendation_id)
    	client_assessment_barrier_recommendation_cpp_snapshot_object = AssessmentBarrierRecommendationCppSnapshot.new
    	client_assessment_barrier_recommendation_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_assessment_barrier_recommendation_cpp_snapshot_object.client_assessment_id = client_assessment_barrier_recommendation_object.client_assessment_id
    	client_assessment_barrier_recommendation_cpp_snapshot_object.barrier_id = client_assessment_barrier_recommendation_object.barrier_id
    	client_assessment_barrier_recommendation_cpp_snapshot_object.recommendation_id = client_assessment_barrier_recommendation_object.recommendation_id
    	client_assessment_barrier_recommendation_cpp_snapshot_object.comments = client_assessment_barrier_recommendation_object.comments
    	client_assessment_barrier_recommendation_cpp_snapshot_object.assessment_barrier_recommendation_created_by = client_assessment_barrier_recommendation_object.created_by
    	client_assessment_barrier_recommendation_cpp_snapshot_object.assessment_barrier_recommendation_updated_by = client_assessment_barrier_recommendation_object.updated_by
    	client_assessment_barrier_recommendation_cpp_snapshot_object.assessment_barrier_recommendation_created_at = client_assessment_barrier_recommendation_object.created_at
    	client_assessment_barrier_recommendation_cpp_snapshot_object.assessment_barrier_recommendation_updated_at = client_assessment_barrier_recommendation_object.updated_at
    	client_assessment_barrier_recommendation_cpp_snapshot_object.parent_primary_key_id = client_assessment_barrier_recommendation_object.id
    	return client_assessment_barrier_recommendation_cpp_snapshot_object
    end



    # 6.1 assessment_strengths_cpp_snapshot
     def self.client_assessment_strength_cpp_snapshot_each_record(arg_assessment_strength_id,arg_career_pathway_plan_id)
    	client_assessment_strength_object=AssessmentStrength.find(arg_assessment_strength_id)
    	client_assessment_strength_cpp_snapshot_object = AssessmentStrengthsCppSnapshot.new
    	client_assessment_strength_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_assessment_strength_cpp_snapshot_object.client_assessment_id = client_assessment_strength_object.client_assessment_id
    	client_assessment_strength_cpp_snapshot_object.assessment_sub_section_id = client_assessment_strength_object.assessment_sub_section_id
    	client_assessment_strength_cpp_snapshot_object.comments = client_assessment_strength_object.comments
    	client_assessment_strength_cpp_snapshot_object.display_order = client_assessment_strength_object.display_order
    	client_assessment_strength_cpp_snapshot_object.assessment_strength_created_by = client_assessment_strength_object.created_by
    	client_assessment_strength_cpp_snapshot_object.assessment_strength_updated_by = client_assessment_strength_object.updated_by
    	client_assessment_strength_cpp_snapshot_object.assessment_strength_created_at = client_assessment_strength_object.created_at
    	client_assessment_strength_cpp_snapshot_object.assessment_strength_updated_at = client_assessment_strength_object.updated_at
    	client_assessment_strength_cpp_snapshot_object.parent_primary_key_id = client_assessment_strength_object.id
    	return client_assessment_strength_cpp_snapshot_object
    end


    # 8.1 Action_plan_cpp_snapshot
     def self.client_assessment_action_plan_cpp_snapshot_each_record(arg_action_plan_id,arg_career_pathway_plan_id)
    	client_action_plan_object=ActionPlan.find(arg_action_plan_id)
    	client_action_plan_cpp_snapshot_object = ActionPlanCppSnapshot.new
    	client_action_plan_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_action_plan_cpp_snapshot_object.employment_readiness_plan_id = client_action_plan_object.employment_readiness_plan_id
    	client_action_plan_cpp_snapshot_object.client_id = client_action_plan_object.client_id

    	client_action_plan_cpp_snapshot_object.household_id = client_action_plan_object.household_id
    	client_action_plan_cpp_snapshot_object.program_unit_id = client_action_plan_object.program_unit_id
    	client_action_plan_cpp_snapshot_object.action_plan_type= client_action_plan_object.action_plan_type
    	client_action_plan_cpp_snapshot_object.action_plan_status= client_action_plan_object.action_plan_status
    	client_action_plan_cpp_snapshot_object.required_participation_hours= client_action_plan_object.required_participation_hours
    	client_action_plan_cpp_snapshot_object.start_date= client_action_plan_object.start_date
    	client_action_plan_cpp_snapshot_object.end_date= client_action_plan_object.end_date
    	client_action_plan_cpp_snapshot_object.client_agreement_date= client_action_plan_object.client_agreement_date
    	client_action_plan_cpp_snapshot_object.notes= client_action_plan_object.notes


    	client_action_plan_cpp_snapshot_object.action_plan_created_by = client_action_plan_object.created_by
    	client_action_plan_cpp_snapshot_object.action_plan_updated_by = client_action_plan_object.updated_by
    	client_action_plan_cpp_snapshot_object.action_plan_created_at = client_action_plan_object.created_at
    	client_action_plan_cpp_snapshot_object.action_plan_updated_at = client_action_plan_object.updated_at
    	client_action_plan_cpp_snapshot_object.parent_primary_key_id = client_action_plan_object.id
    	return client_action_plan_cpp_snapshot_object
    end



    # 9.1 action_plan_details_cpp_snapshot
     def self.client_assessment_action_plan_details_cpp_snapshot_each_record(arg_action_plan_detail_id,arg_career_pathway_plan_id)
    	client_action_plan_detail_object=ActionPlanDetail.find(arg_action_plan_detail_id)
    	client_action_plan_detail_cpp_snapshot_object = ActionPlanDetailCppSnapshot.new
    	client_action_plan_detail_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	client_action_plan_detail_cpp_snapshot_object.action_plan_id = client_action_plan_detail_object.action_plan_id
    	client_action_plan_detail_cpp_snapshot_object.barrier_id = client_action_plan_detail_object.barrier_id
    	client_action_plan_detail_cpp_snapshot_object.provider_id= client_action_plan_detail_object.provider_id
    	client_action_plan_detail_cpp_snapshot_object.reference_id= client_action_plan_detail_object.reference_id
    	client_action_plan_detail_cpp_snapshot_object.activity_classfication= client_action_plan_detail_object.activity_classfication
    	client_action_plan_detail_cpp_snapshot_object.activity_type= client_action_plan_detail_object.activity_type
    	client_action_plan_detail_cpp_snapshot_object.component_type= client_action_plan_detail_object.component_type
    	client_action_plan_detail_cpp_snapshot_object.entity_type= client_action_plan_detail_object.entity_type
    	client_action_plan_detail_cpp_snapshot_object.activity_status= client_action_plan_detail_object.activity_status
    	client_action_plan_detail_cpp_snapshot_object.hours_per_day = client_action_plan_detail_object.hours_per_day
    	client_action_plan_detail_cpp_snapshot_object.start_date = client_action_plan_detail_object.start_date
    	client_action_plan_detail_cpp_snapshot_object.end_date = client_action_plan_detail_object.end_date
    	client_action_plan_detail_cpp_snapshot_object.client_agreement_date = client_action_plan_detail_object.client_agreement_date
    	client_action_plan_detail_cpp_snapshot_object.notes = client_action_plan_detail_object.notes
    	client_action_plan_detail_cpp_snapshot_object.action_plan_detail_created_by = client_action_plan_detail_object.created_by
    	client_action_plan_detail_cpp_snapshot_object.action_plan_detail_updated_by = client_action_plan_detail_object.updated_by
    	client_action_plan_detail_cpp_snapshot_object.action_plan_detail_created_at = client_action_plan_detail_object.created_at
    	client_action_plan_detail_cpp_snapshot_object.action_plan_detail_updated_at = client_action_plan_detail_object.updated_at
    	client_action_plan_detail_cpp_snapshot_object.parent_primary_key_id = client_action_plan_detail_object.id
    	return client_action_plan_detail_cpp_snapshot_object
    end




    # 10.1 schedules_cpp_snapshot
     def self.client_action_plan_detail_schedule_cpp_snapshot_each_record(arg_schedule_id,arg_career_pathway_plan_id)
    	client_schedule_object=Schedule.find(arg_schedule_id)
    	schedule_cpp_snapshot_object = ScheduleCppSnapshot.new
    	schedule_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
    	schedule_cpp_snapshot_object.entity = client_schedule_object.entity
    	schedule_cpp_snapshot_object.reference_id = client_schedule_object.reference_id
    	schedule_cpp_snapshot_object.day_of_week = client_schedule_object.day_of_week
    	schedule_cpp_snapshot_object.time_of_day = client_schedule_object.time_of_day
    	schedule_cpp_snapshot_object.duration= client_schedule_object.duration
    	schedule_cpp_snapshot_object.recurring= client_schedule_object.recurring
    	schedule_cpp_snapshot_object.action_plan_schedule_created_by = client_schedule_object.created_by
    	schedule_cpp_snapshot_object.action_plan_schedule_updated_by = client_schedule_object.updated_by
    	schedule_cpp_snapshot_object.action_plan_schedule_created_at = client_schedule_object.created_at
    	schedule_cpp_snapshot_object.action_plan_schedule_updated_at = client_schedule_object.updated_at
    	schedule_cpp_snapshot_object.parent_primary_key_id = client_schedule_object.id
    	return schedule_cpp_snapshot_object
    end




     # 11.1 service authorization each record
    def self.client_assessment_service_authorization_cpp_snapshot_each_record(arg_service_authorization_id,arg_career_pathway_plan_id)
    	# similar to 9.1
    	client_service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
		service_authorization_cpp_snapshot_object = ServiceAuthorizationCppSnapshot.new
		service_authorization_cpp_snapshot_object.career_pathway_plan_id = arg_career_pathway_plan_id
		service_authorization_cpp_snapshot_object.parent_primary_key_id = client_service_authorization_object.id
		service_authorization_cpp_snapshot_object.provider_id = client_service_authorization_object.provider_id
		service_authorization_cpp_snapshot_object.program_unit_id = client_service_authorization_object.program_unit_id
		service_authorization_cpp_snapshot_object.client_id = client_service_authorization_object.client_id
		service_authorization_cpp_snapshot_object.service_start_date = client_service_authorization_object.service_start_date
		service_authorization_cpp_snapshot_object.service_end_date = client_service_authorization_object.service_end_date
		service_authorization_cpp_snapshot_object.trip_start_address_line1 = client_service_authorization_object.trip_start_address_line1
		service_authorization_cpp_snapshot_object.trip_start_address_line2 = client_service_authorization_object.trip_start_address_line2
		service_authorization_cpp_snapshot_object.trip_start_address_city = client_service_authorization_object.trip_start_address_city
		service_authorization_cpp_snapshot_object.trip_start_address_state = client_service_authorization_object.trip_start_address_state
		service_authorization_cpp_snapshot_object.trip_start_address_zip = client_service_authorization_object.trip_start_address_zip
		service_authorization_cpp_snapshot_object.trip_end_address_line1 = client_service_authorization_object.trip_end_address_line1
		service_authorization_cpp_snapshot_object.trip_end_address_line2 = client_service_authorization_object.trip_end_address_line2
		service_authorization_cpp_snapshot_object.trip_end_address_city = client_service_authorization_object.trip_end_address_city
		service_authorization_cpp_snapshot_object.trip_end_address_state = client_service_authorization_object.trip_end_address_state
		service_authorization_cpp_snapshot_object.trip_end_address_zip = client_service_authorization_object.trip_end_address_zip
		service_authorization_cpp_snapshot_object.outcome_achieved = client_service_authorization_object.outcome_achieved
		service_authorization_cpp_snapshot_object.status = client_service_authorization_object.status
		service_authorization_cpp_snapshot_object.service_type = client_service_authorization_object.service_type
		service_authorization_cpp_snapshot_object.supportive_service_flag = client_service_authorization_object.supportive_service_flag
		service_authorization_cpp_snapshot_object.service_date = client_service_authorization_object.service_date
		service_authorization_cpp_snapshot_object.action_plan_detail_id = client_service_authorization_object.action_plan_detail_id
		service_authorization_cpp_snapshot_object.barrier_id = client_service_authorization_object.barrier_id
		service_authorization_cpp_snapshot_object.notes = client_service_authorization_object.notes
		service_authorization_cpp_snapshot_object.client_agreement_date = client_service_authorization_object.client_agreement_date
		service_authorization_cpp_snapshot_object.service_authorization_created_by = client_service_authorization_object.created_by
		service_authorization_cpp_snapshot_object.service_authorization_updated_by = client_service_authorization_object.updated_by
		service_authorization_cpp_snapshot_object.service_authorization_created_at = client_service_authorization_object.created_at
		service_authorization_cpp_snapshot_object.service_authorization_updated_at = client_service_authorization_object.updated_at
		return service_authorization_cpp_snapshot_object
    end


    def self.can_cpp_be_created?(arg_client_id)
    	step1 = ClientAssessment.joins(" INNER JOIN client_assessment_answers ON client_assessment_answers.client_assessment_id = client_assessments.id
									     INNER JOIN assessment_barriers ON  assessment_barriers.client_assessment_id = client_assessments.id
									     INNER JOIN action_plans ON action_plans.client_id = client_assessments.client_id
									     INNER JOIN action_plan_details ON action_plan_details.action_plan_id = action_plans.id
									     INNER JOIN schedules ON schedules.reference_id = action_plan_details.id
									     ")
		step2 = step1.where("client_assessments.client_id = ?
			                and action_plans.action_plan_status = 6043
			                and action_plan_details.activity_status = 6043
			                and action_plan_details.client_agreement_date is null",arg_client_id).count

		if step2 > 0
			msg = "YES"
		else
			msg = "NO"
		end
		return msg
    end



    # def self.get_signed_cpp_plans(arg_client_id)
    # 	# get Assessment for the passed client_id
    # 	client_assessment_collection = ClientAssessment.where("client_id = ?",arg_client_id)
   	# 	client_assessment_object = client_assessment_collection.first
    # 		# get pending cpp for the assessment id.
   	# 	cpp_collection = CareerPathwayPlan.where("client_assessment_id = ? and client_signed_date is not null",client_assessment_object.id)
    # 	return cpp_collection
    # end

  #   def self.get_open_employment_action_plan(arg_assessment_id)
  #   	step1 = ActionPlan.joins("INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id")
  #   	step2 = step1.where("employment_readiness_plans.client_assessment_id = ? and action_plan_type = 2976 and (action_plan_status = 6043 OR end_date is null)",arg_assessment_id)
		# employment_plan_collection = step2
		# return employment_plan_collection
  #   end

    def self.get_employment_action_plan(arg_assessment_id)
    	step1 = ActionPlan.joins("INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id")
    	step2 = step1.where("employment_readiness_plans.client_assessment_id = ? and action_plan_type = 2976",arg_assessment_id)
		employment_plan_collection = step2
		return employment_plan_collection
    end

    def self.get_barrier_reduction_plan(arg_assessment_id)
    	step1 = ActionPlan.joins("INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id")
    	step2 = step1.where("employment_readiness_plans.client_assessment_id = ? and action_plan_type = 2977",arg_assessment_id)
		employment_plan_collection = step2
		return employment_plan_collection
    end


  #   def self.get_open_barrier_reduction_plan(arg_assessment_id)
  #   	step1 = ActionPlan.joins("INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id")
  #   	step2 = step1.where("employment_readiness_plans.client_assessment_id = ? and action_plan_type = 2977  and (action_plan_status = 6043 OR end_date is null)",arg_assessment_id)
		# employment_plan_collection = step2
		# return employment_plan_collection
  #   end

    def self.get_open_action_plan_details(arg_program_unit_id,arg_client_id)
    	step1 = ActionPlanDetail.joins("INNER JOIN schedules
    		                            ON action_plan_details.id = schedules.reference_id
    		                           INNER JOIN  action_plans
    		                            ON action_plan_details.action_plan_id = action_plans.id
    									")
    	step2 = step1.where("action_plans.program_unit_id = ?
    		                 and action_plans.client_id = ?
    		                 and action_plan_details.activity_status = 6043
    		                 and action_plans.action_plan_status = 6043
    		                 ",arg_program_unit_id,arg_client_id)
    	step3 = step2.select("action_plan_details.id as id,
    		                  action_plan_details.reference_id as reference_id,
    		                  action_plan_details.barrier_id as barrier_id,
    		                  action_plan_details.activity_type as activity_type,
    		                  action_plan_details.provider_id as provider_id,
    		                  action_plan_details.component_type as component_type,
    		                  action_plan_details.hours_per_day as hours_per_day,
    		                  schedules.day_of_week as day_of_week,
    		                  action_plan_details.start_date as start_date,
    		                  action_plan_details.end_date as end_date,
    		                  action_plans.client_id
    		                  ").order("action_plan_details.id ASC")


    	return step3
    end

    def self.get_open_employment_plan_details(arg_program_unit_id,arg_client_id)
    	step1 = ActionPlanDetail.joins("INNER JOIN schedules
    		                            ON action_plan_details.id = schedules.reference_id
    		                           INNER JOIN  action_plans
    		                            ON action_plan_details.action_plan_id = action_plans.id
    									")
    	step2 = step1.where("action_plans.program_unit_id = ?
    		                 and action_plans.client_id = ?
    		                 and action_plan_details.activity_status = 6043
    		                 and action_plans.action_plan_status = 6043
    		                 ",arg_program_unit_id,arg_client_id).order("action_plan_details.id ASC")
    	return step2
    end

	 # def self.open_action_plan_details_from_action_plan_id(arg_action_plan_id)
	 #    	step1 = ActionPlanDetail.joins("INNER JOIN schedules ON action_plan_details.id = schedules.reference_id
	 #    									")
	 #    	step2 = step1.where("action_plan_details.action_plan_id = ? and action_plan_details.id = action_plan_details.reference_id and  (activity_status = 6043 or end_date is null)",arg_action_plan_id)
	 #    	step3 = step2.select("action_plan_details.*,schedules.*").order("action_plan_details.id ASC")
	 # end

    def self.open_supportive_services_for_action_plan_detail(arg_action_plan_detail_id,arg_career_pathway_plan_id)

		if arg_career_pathway_plan_id == 0
			# Non snapshot tables
			# step1 = ActionPlanDetail.where("reference_id = ? and (activity_status = 6043 or end_date is null) and entity_type = 6294",arg_action_plan_detail_id)
			step1 = ServiceAuthorization.where("action_plan_detail_id = ? and supportive_service_flag = 'Y'",arg_action_plan_detail_id)
			open_supportive_service_collection_for_action_plan_detail = step1
		else
			# snapshot tables
			# step1 = ActionPlanDetailCppSnapshot.where("reference_id = ? and career_pathway_plan_id = ? and entity_type = 6294",arg_action_plan_detail_id,arg_career_pathway_plan_id)
			step1 = ServiceAuthorizationCppSnapshot.where("action_plan_detail_id = ? and career_pathway_plan_id = ? and supportive_service_flag = 'Y'",arg_action_plan_detail_id,arg_career_pathway_plan_id)
			open_supportive_service_collection_for_action_plan_detail = step1
		end
		return open_supportive_service_collection_for_action_plan_detail
    end


    def self.get_current_assessment_id(arg_client_id)
    	client_assessment_collection = ClientAssessment.where("client_id = ?",arg_client_id)
    	return client_assessment_collection
    end


    def self.planned_work_participation_hours_for_program_unit(arg_program_unit_id)
    	step1 = ProgramUnit.joins(" INNER JOIN program_wizards
									ON (program_units.id = program_wizards.program_unit_id
    									and selected_for_planning = 'Y'
    									)
 									INNER JOIN program_benefit_members
									ON  (program_wizards.id = program_benefit_members.program_wizard_id
     									 and program_benefit_members.member_status = 4468
     									 )
									INNER JOIN client_characteristics
									ON (client_characteristics.CLIENT_ID = program_benefit_members.client_id
    									and characteristic_id in (select CAST( value AS integer)
																  from system_params
																  where system_param_categories_id = 9
																  and key = 'CPP_WORK_CHARACTERISTICS'
																  )
    									and (end_date is null or end_date > current_date)
    									)
									INNER JOIN action_plans
									ON (action_plans.CLIENT_ID =  program_benefit_members.client_id and
										(action_plans.end_date is null or action_plans.end_date > current_date))
   									INNER JOIN action_plan_details
									ON action_plans.id = action_plan_details.action_plan_id
									INNER JOIN schedules
									ON schedules.reference_id = action_plan_details.id
									INNER JOIN codetable_items as activity_types
									on activity_types.id = action_plan_details.activity_type
									inner join CLIENTS
									ON CLIENTS.id = program_benefit_members.client_id
								")
		step2 = step1.where("program_units.ID = ? and action_plans.program_unit_ID = ?",arg_program_unit_id,arg_program_unit_id)
		step3 = step2.select(" distinct clients.last_name,
                					    clients.first_name,
										program_benefit_members.client_id as client_id,
								        action_plan_details.activity_type,
       									activity_types.short_description as activity_description,
       									schedules.duration as number_of_weeks,
       									action_plan_details.start_date,
									      ( select (array_upper(B.day_of_week, 1)*A.hours_per_day)
										from action_plan_details A
										INNER JOIN schedules B
										ON B.reference_id = A.id
										INNER JOIN codetable_items core_activities
										ON (core_activities.code_table_id = 173
											and core_activities.id = A.component_type
										    )
										WHERE A.ID = action_plan_details.ID
									      ) as core_hours,

									      ( select (array_upper(B.day_of_week, 1)*A.hours_per_day)
										from action_plan_details A
										INNER JOIN schedules B
										ON B.reference_id = A.id
										INNER JOIN codetable_items non_core_activities
										ON (non_core_activities.code_table_id = 174
											and non_core_activities.id = A.component_type
										    )
										WHERE A.ID = action_plan_details.ID) as non_core_hours
                            ")
		step4 = step3.order("program_benefit_members.client_id ASC,action_plan_details.start_date ASC")
		planned_activity_hours_collection = step4
		return planned_activity_hours_collection
    end


    def self.no_cpp_plan_with_complete_status_found(arg_client_id)
    	cpp_collection = where("client_signature = ? and state = 6165",arg_client_id)
    	if cpp_collection.blank?
    		return true
    	else
    		return false
    	end
    	# where("client_signature = ? and state = 6165",arg_client_id).count == 0
    end

    def self.no_cpp_plan_with_complete_and_requested_status_found(arg_client_id)
    	cpp_collection = where("client_signature = ? and state in(6165,6373)",arg_client_id)
    	# complete: 6165
	    #requested: 6373
    	if cpp_collection.blank?
    		return true
    	else
    		return false
    	end
    	# where("client_signature = ? and state = 6165",arg_client_id).count == 0
    end

    def self.no_cpp_plan_with_approved_status_found(arg_client_id)
    	cpp_collection = where("client_signature = ? and state !=6166",arg_client_id)
    	# complete: 6165
	    #requested: 6373
    	if cpp_collection.blank?
    		return true
    	else
    		return false
    	end
    	# where("client_signature = ? and state = 6165",arg_client_id).count == 0
    end

    def self.get_completed_and_requested_cpp_plan_list_for_selected_client(arg_client_id)
    	#state - 6166 - approved
    	step1 = joins("INNER JOIN program_units ON program_units.id = career_pathway_plans.program_unit_id")
    	step2 = step1.where("career_pathway_plans.client_signature = ? and career_pathway_plans.state in (6165,6373)",arg_client_id)
    	step3 = step2.select("career_pathway_plans.*,program_units.service_program_id").order("id desc")
    	return step3
    end

    # Manoj - 04/17/2016 - start - Summary total hours in activities
	def self.get_core_hours_from_activities(arg_client_id)
		step1 = ActionPlan.joins("INNER JOIN action_plan_details
								  ON action_plans.id = action_plan_details.action_plan_id
								  INNER JOIN schedules
								  ON schedules.reference_id = action_plan_details.id
								  INNER JOIN codetable_items core_activities
								  ON (core_activities.code_table_id = 173
									  and core_activities.id = action_plan_details.component_type
									 )
								")
		step2 = step1.where("action_plans.client_id = ?
                             and action_plans.action_plan_status = 6043
                             and action_plan_details.activity_status = 6043
			                 ",arg_client_id)
		step3 = step2.select("(array_upper(schedules.day_of_week, 1)*action_plan_details.hours_per_day) as hours_per_week")
		core_hours_collection = step3
		if core_hours_collection.present?
			li_total_hours_per_week = 0
			core_hours_collection.each do |each_activity|
				li_total_hours_per_week = li_total_hours_per_week + each_activity.hours_per_week
			end
			core_hours_per_week = li_total_hours_per_week
		else
			core_hours_per_week = 0
		end
		return core_hours_per_week

	end

	def self.get_non_core_hours_from_activities(arg_client_id)
		step1 = ActionPlan.joins("INNER JOIN action_plan_details
								  ON action_plans.id = action_plan_details.action_plan_id
								  INNER JOIN schedules
								  ON schedules.reference_id = action_plan_details.id
								  INNER JOIN codetable_items core_activities
								  ON (core_activities.code_table_id = 174
									  and core_activities.id = action_plan_details.component_type
									 )
								")
		step2 = step1.where("action_plans.client_id = ?
                             and action_plans.action_plan_status = 6043
                             and action_plan_details.activity_status = 6043
			                 ",arg_client_id)
		step3 = step2.select("(array_upper(schedules.day_of_week, 1)*action_plan_details.hours_per_day) as hours_per_week")
		non_core_hours_collection = step3
		if non_core_hours_collection.present?
			li_total_hours_per_week = 0
			non_core_hours_collection.each do |each_activity|
				li_total_hours_per_week = li_total_hours_per_week + each_activity.hours_per_week
			end
			non_core_hours_per_week = li_total_hours_per_week

		else
			non_core_hours_per_week = 0

		end
		return non_core_hours_per_week

	end


	def self.is_passed_barrier_addressed_in_pending_cpp?(arg_client_id,arg_action_plan_id,arg_barrier_id)
				# postgresql query
				# 		select action_plan_details.*
				# from client_assessments
				# inner join
				# assessment_barriers
				# on client_assessments.id = assessment_barriers.client_assessment_id
				# inner join action_plans
				# on (
				#     action_plans.client_id =  client_assessments.client_id
				#     and action_plans.action_plan_status = 6043
				#     and action_plans.end_date is null
				#    )
				# inner join action_plan_details
				# on (action_plan_details.action_plan_id = action_plans.id
				#     and action_plan_details.activity_status = 6043
				#     and action_plan_details.end_date is null )
				# where
				# client_assessments.client_id = 1536
				# and assessment_barriers.barrier_id = 7
				# and action_plans.id = 316
				# and action_plan_details.barrier_id = 7
		step1 = ClientAssessment.joins("inner join assessment_barriers
										on client_assessments.id = assessment_barriers.client_assessment_id
										inner join action_plans
										on (
										    action_plans.client_id =  client_assessments.client_id
										    and action_plans.action_plan_status = 6043
										    and action_plans.end_date is null
										   )
										inner join action_plan_details
										on (action_plan_details.action_plan_id = action_plans.id
										    and action_plan_details.activity_status = 6043
										    and action_plan_details.end_date is null
										    and action_plan_details.activity_type != 6770)
										")
		step2 = step1.where("client_assessments.client_id = ?
							 and assessment_barriers.barrier_id = ?
							 and action_plans.id = ?
							 and action_plan_details.barrier_id = ?",arg_client_id,arg_barrier_id,arg_action_plan_id,arg_barrier_id
							)
		step3 = step2.select("action_plan_details.id")
		if step3.present?
			return true
		else
			return false
		end
	end

	def self.is_passed_barrier_addressed_in_approved_cpp?(arg_career_pathway_plan_id,arg_barrier_id)
				# postgresql query
				# select * from action_plan_detail_cpp_snapshots
				# where career_pathway_plan_id = ?
				# and barrier_id = ?
				# and action_plan_detail_cpp_snapshots.activity_type != 6770
		step1 = ActionPlanDetailCppSnapshot.where("action_plan_detail_cpp_snapshots.career_pathway_plan_id = ?
			                                       and action_plan_detail_cpp_snapshots.barrier_id = ?
			                                       and action_plan_detail_cpp_snapshots.activity_type != 6770
			                                       ",arg_career_pathway_plan_id,arg_barrier_id
			                                      )

		if step1.present?
			return true
		else
			return false
		end
	end

end


