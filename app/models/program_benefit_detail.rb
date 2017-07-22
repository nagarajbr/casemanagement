class ProgramBenefitDetail < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramBenftDetlVersion',:on => [:update, :destroy]


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

  def self.get_program_benefit_detail_collection(arg_run_id,arg_month_sequence)
    program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
  end

  def self.program_benefit_detail_from_program_unit_id(arg_program_unit_id)
      step1 = joins("inner join program_wizards on program_wizards.run_id = program_benefit_details.run_id ")
      step2 = step1.where("program_unit_id = ? ",arg_program_unit_id).order("program_wizards.submit_date ")
      step3 = step2.present?
      return step2

  end

  def self.get_program_benefit_detail_collection_by_run_id(arg_run_id)
    program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? ",arg_run_id)
  end

end
