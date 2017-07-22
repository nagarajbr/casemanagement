class ProgramUnitStateTransition < ActiveRecord::Base
  belongs_to :program_unit
  def self.get_latest_transition_record(arg_program_unit_id)
  	where("program_unit_id = ?",arg_program_unit_id).order("created_at DESC").first
  end
end
