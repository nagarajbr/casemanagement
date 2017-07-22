class ProgramStandardDetail < ActiveRecord::Base
  belongs_to :program_standard


	 def self.get_program_limits(program_standard_id,effective_date)
  	     where("program_standard_id = ? and effective_date <= ? ", program_standard_id,effective_date).order(effective_date: :desc)
     end

     def self.get_income_eligibility_standard(arg_program_standard_id, arg_effective_date)
     	get_program_limits(arg_program_standard_id, arg_effective_date)
     end
end
