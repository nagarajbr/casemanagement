class FamilyStruct
	#  Author Rao
	attr_accessor :case_scenario, :case_type, :number_of_members, :members, :adults_struct, :active_members,
				  :child_struct, :budget_eligible_ind, :benefit_amount, :program_unit_id, :member_status,
				  :validation_level, :service_program_id, :validation_date, :ineligible_codes,
				  :any_eligible_service_program, :application_id, :service_programs_ineligible_codes, :eligible_service_programs

	def initialize
		@ineligible_codes = {}
		@any_eligible_service_program = false
		@adults_struct = []
		@service_programs_ineligible_codes = {}
		@benefit_amount = {}
		@budget_eligible_ind = {}
		@eligible_service_programs = []
		@active_members = []
		@member_status = {}
	end
end