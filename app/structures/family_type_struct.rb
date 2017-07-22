class FamilyTypeStruct
	#  Author Kiran
	#  Modifications : Manoj Patil 09/26/2014
	#  Modification Description: Added case_type_integer to reflect code table number- which will be populated in Program_unit table.
	# Modified by Manoj 09/30/2014 - Added program_unit_id
	attr_accessor :family_type, :minor_parent_case, :child, :adult_list, :child_list, :parents_list, :application_id,
				:case_type, :case_type_integer, :program_unit_id, :program_wizard_id, :members_list, :service_program_id, :run_id, :month_sequence,
				:run_month, :application_date, :ed_activie_members_list, :validation_level, :validation_date, :household_id, :validate_race_information
end