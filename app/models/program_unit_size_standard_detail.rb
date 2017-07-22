class ProgramUnitSizeStandardDetail < ActiveRecord::Base
	def self.get_program_grant_amount(arg_unit_size, arg_run_month, arg_standard_type)
		where("program_unit_size = ? and effective_date <= ? and standard_type = ?", arg_unit_size, arg_run_month, arg_standard_type).
				order(effective_date: :desc)



	end
end
