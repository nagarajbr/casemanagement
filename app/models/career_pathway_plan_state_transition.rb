class CareerPathwayPlanStateTransition < ActiveRecord::Base
  belongs_to :career_pathway_plan
  def self.get_latest_transition_record(arg_cpp_id)
  	where("career_pathway_plan_id = ?",arg_cpp_id).order("created_at DESC").first
  end
end
