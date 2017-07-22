class PrescreenHouseholdQAnswer < ActiveRecord::Base
	belongs_to :prescreen_household


# 	def self.determine_workforce_programs(arg_household_pre_screening_id)
# 		# Mapping of answers to workforce program.
# 		#  Question /answer = Yes             =  Workforce service Program
# # Anybody in the house jobseeker	= TEA	/Work Pays	/Youth Program
# # Anybody in the house currently working and wanting to upgrade	= Work Pays
# # Anybody in the house is unemployed recently	= UI
# # Anybody in the house is long term unemployed	= UI/	EUC	/TRA
# # Anybody in the house is unemployed due to company closure recently = 	WIA
# # Anybody in the house is unemployed due to outsourced job	= TAA
# # Do you need help with payment of housing utilities	= LIHEAP
# # Any member in the house is disabled
# # Any member in the house is a Veteran	= AVET
# # Based on age if (> 50)	= MWI

# # You may also want to explore = 	CRC	/ Microsoft IT Academy
# #  Mapping Logic will be revisited after consulting clients - 2nd iteration
# #  Now populating

# 		# Delete & insert records into results table.
# 		PrescreenHouseholdResult.where("prescreen_household_id = ?",arg_household_pre_screening_id).destroy_all


# 		workforce_program_collection =  ServiceProgram.where("id in (5,6,7,8,9,10,12,13,14,15,16)")
# 		if workforce_program_collection.present?
# 			workforce_program_collection.each do |arg_prgm|
# 				result_object = PrescreenHouseholdResult.new
# 				result_object.prescreen_household_id = arg_household_pre_screening_id
# 				result_object.service_program_category_id = arg_prgm.id
# 				result_object.save
# 			end
# 		end

# 		supportive_service_program_collection =  ServiceProgram.where("id in (18,19,20)")
# 		if supportive_service_program_collection.present?
# 			supportive_service_program_collection.each do |arg_prgm|
# 				result_object = PrescreenHouseholdResult.new
# 				result_object.prescreen_household_id = arg_household_pre_screening_id
# 				result_object.service_program_category_id = arg_prgm.id
# 				result_object.save
# 			end
# 		end
# 	end



	def self.get_answered_questions(arg_household_pre_screening_id)
		where("prescreen_household_id = ? and answer_flag in ('1','0')",arg_household_pre_screening_id)
	end






end





