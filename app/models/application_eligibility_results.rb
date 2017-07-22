class ApplicationEligibilityResults < ActiveRecord::Base
has_paper_trail :class_name => 'AppEligResultVersion' ,:on => [:update, :destroy]
	def self.delete_results_for_the_application(arg_application_id)
		where("application_id = ?",arg_application_id).destroy_all
	end

	def self.get_the_results_list(arg_application_id)
		where("application_id = ?",arg_application_id).order("client_id ASC")
	end

	# def self.get_the_results_list_for_the_client(arg_client_id)
	# 	where("client_id = ?", arg_client_id)
	# end

	def self.get_the_results_list_for_the_client_and_program_unit_id(arg_client_id,arg_program_unit_id)
		program_unit_object = ProgramUnit.find(arg_program_unit_id)
		l_application_id = 	program_unit_object.client_application_id
		where("client_id = ? and application_id = ?", arg_client_id,l_application_id).order("client_id ASC")
	end

	def self.delete_results_based_on_application_id_and_client_id(arg_application_id, arg_client_id)
		where("application_id = ? and client_id = ?",arg_application_id, arg_client_id).destroy_all
	end

	def self.get_the_results_list_based_on_program_unit_id(arg_program_unit_id)
		step1 = joins("INNER JOIN program_unit_members ON program_unit_members.client_id = application_eligibility_results.client_id
					   INNER JOIN program_units ON program_units.client_application_id = application_eligibility_results.application_id")
        step2 = step1.where("program_unit_members.program_unit_id = ? and program_units.id = ?",arg_program_unit_id, arg_program_unit_id)
        step3 = step2.select("application_eligibility_results.*")
        return step3
	end

	def self.get_the_warning_results_list_based_on_program_unit_id(arg_program_unit_id)
		step1 = joins("INNER JOIN program_unit_members ON program_unit_members.client_id = application_eligibility_results.client_id
					   INNER JOIN program_units ON program_units.client_application_id = application_eligibility_results.application_id")
        step2 = step1.where("program_unit_members.program_unit_id = ? and program_units.id = ? and application_eligibility_results.result = false",arg_program_unit_id, arg_program_unit_id)
        step3 = step2.select("application_eligibility_results.*")
        return step3
	end
end