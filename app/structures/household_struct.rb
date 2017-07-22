class HouseholdStruct
	#  Author Thirumal
	attr_accessor :family_sequence, :family_structure, :unporcessed_adult_list, :unporcessed_child_list, :any_eligible_program_units,
				  :used_open_pgus
	def initialize
		@family_sequence = Array.new
		@family_structure = Array.new
		@any_eligible_program_units = false
		@used_open_pgus = Array.new
	end
end