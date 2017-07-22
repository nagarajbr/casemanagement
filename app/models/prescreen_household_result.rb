class PrescreenHouseholdResult < ActiveRecord::Base
	belongs_to :prescreen_household

	def self.pre_screen_household_work_force_programs(arg_prescreen_household_id)
		# PrescreenHouseholdResult.where("service_program_category_id IN (5,6,7,8,9,10,12,13,14,15,16) and prescreen_household_id = ?",arg_prescreen_household_id).order("service_program_category_id ASC")
		PrescreenHouseholdResult.where("service_program_category_id NOT IN (13,14,28) and prescreen_household_id = ?",arg_prescreen_household_id).select("service_program_category_id").distinct.order("service_program_category_id ASC")
		#Step2 = Step1.select("service_program_category_id").distinct.order("service_program_category_id ASC")

		#return Step1

	end

	def self.pre_screen_household_supportive_service_programs(arg_prescreen_household_id)
		#PrescreenHouseholdResult.where("service_program_category_id IN (19,20,21) and prescreen_household_id = ?",arg_prescreen_household_id).order("service_program_category_id ASC")
		PrescreenHouseholdResult.where("service_program_category_id IN (13,14,28) and prescreen_household_id = ?",arg_prescreen_household_id).select("service_program_category_id").distinct.order("service_program_category_id ASC")
		#Step2 = Step1.s
		#return Step1
	end
end

