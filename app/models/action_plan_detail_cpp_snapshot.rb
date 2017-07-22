class ActionPlanDetailCppSnapshot < ActiveRecord::Base
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


    def self.open_action_plan_details_cpp_snapshot(arg_career_pathway_plan_id,arg_action_plan_id)
    	step1 = ActionPlanDetailCppSnapshot.joins("INNER JOIN schedule_cpp_snapshots ON (action_plan_detail_cpp_snapshots.parent_primary_key_id = schedule_cpp_snapshots.reference_id
                                                                                      AND action_plan_detail_cpp_snapshots.career_pathway_plan_id = schedule_cpp_snapshots.career_pathway_plan_id)
                                           ")
        step2 = step1.where("action_plan_detail_cpp_snapshots.action_plan_id = ?
                             and action_plan_detail_cpp_snapshots.career_pathway_plan_id = ?
                             and action_plan_detail_cpp_snapshots.parent_primary_key_id = action_plan_detail_cpp_snapshots.reference_id ",arg_action_plan_id,arg_career_pathway_plan_id)
        step3 = step2.select("action_plan_detail_cpp_snapshots.*,schedule_cpp_snapshots.*").order("action_plan_detail_cpp_snapshots.parent_primary_key_id ASC")
    end


    def self.get_open_action_plan_details_from_snapshot(arg_career_pathway_plan_id)
        step1 = ActionPlanDetailCppSnapshot.joins("INNER JOIN schedule_cpp_snapshots
                                                   ON (action_plan_detail_cpp_snapshots.career_pathway_plan_id = schedule_cpp_snapshots.career_pathway_plan_id
                                                       and action_plan_detail_cpp_snapshots.parent_primary_key_id = schedule_cpp_snapshots.reference_id
                                                       )
                                                 ")
        step2 = step1.where("action_plan_detail_cpp_snapshots.career_pathway_plan_id = ?
                             ",arg_career_pathway_plan_id)
        step3 = step2.select("action_plan_detail_cpp_snapshots.parent_primary_key_id as id,
                              action_plan_detail_cpp_snapshots.reference_id as reference_id,
                              action_plan_detail_cpp_snapshots.barrier_id as barrier_id,
                              action_plan_detail_cpp_snapshots.activity_type as activity_type,
                              action_plan_detail_cpp_snapshots.provider_id as provider_id,
                              action_plan_detail_cpp_snapshots.component_type as component_type,
                              action_plan_detail_cpp_snapshots.hours_per_day as hours_per_day,
                              schedule_cpp_snapshots.day_of_week as day_of_week,
                              action_plan_detail_cpp_snapshots.start_date as start_date,
                              action_plan_detail_cpp_snapshots.end_date as end_date
                              ").order("action_plan_detail_cpp_snapshots.parent_primary_key_id ASC")


        return step3
    end

end





