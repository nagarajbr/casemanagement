class EmploymentReadinessPlan < ActiveRecord::Base

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

    def self.save_employment_readiness_pan(arg_assessment_id)
    	employment_readiness_plan_collection = EmploymentReadinessPlan.where("client_assessment_id = ?",arg_assessment_id)
    	if employment_readiness_plan_collection.blank?
    		employment_readiness_plan_object = EmploymentReadinessPlan.new
    	   	employment_readiness_plan_object.client_assessment_id = arg_assessment_id
    	   	employment_readiness_plan_object.save!
    	end
    end

	def self.get_employment_readiness_pan(arg_assessment_id)
        employment_readiness_plan_collection = EmploymentReadinessPlan.where("client_assessment_id = ?",arg_assessment_id)
        employment_readiness_plan_object = employment_readiness_plan_collection.first
    end

	def self.get_employment_readiness_id(arg_client_id)
		step1 = joins("INNER JOIN client_assessments ON client_assessments.id = employment_readiness_plans.client_assessment_id")
	    step2 = step1.where("client_assessments.client_id = ?", arg_client_id)
	    # Rails.logger.debug("//// #{step2.inspect}")
	    if step2.present?
	    	step3 = step2.first.id
	    else
	    	step3 = ""
	    end
	    return step3
	end


	# Manoj - 04/01/2015 - start - Summary total hours in activities
	def self.get_core_hours_from_activities(arg_employment_readiness_plan_id)
		step1 = ActionPlan.joins("INNER JOIN action_plan_details
								  ON action_plans.id = action_plan_details.action_plan_id
								  INNER JOIN schedules
								  ON schedules.reference_id = action_plan_details.id
								  INNER JOIN codetable_items core_activities
								  ON (core_activities.code_table_id = 173
									  and core_activities.id = action_plan_details.component_type
									 )
								")
		step2 = step1.where("action_plans.employment_readiness_plan_id = ?",arg_employment_readiness_plan_id)
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

	def self.get_non_core_hours_from_activities(arg_employment_readiness_plan_id)
		step1 = ActionPlan.joins("INNER JOIN action_plan_details
								  ON action_plans.id = action_plan_details.action_plan_id
								  INNER JOIN schedules
								  ON schedules.reference_id = action_plan_details.id
								  INNER JOIN codetable_items core_activities
								  ON (core_activities.code_table_id = 174
									  and core_activities.id = action_plan_details.component_type
									 )
								")
		step2 = step1.where("action_plans.employment_readiness_plan_id = ?",arg_employment_readiness_plan_id)
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




	# Manoj - 04/01/2015 - end

end



