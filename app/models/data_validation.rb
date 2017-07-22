class DataValidation < ActiveRecord::Base
has_paper_trail :class_name => 'DataValidationVersion' ,:on => [:validation_results]


	  belongs_to :client


	def self.delete_client_information(arg_client_id)
		where("client_id = ?",arg_client_id).destroy_all
	end

	def self.delete_assessment_validation_information(arg_client_id)
		where("client_id = ? and data_item_type in (6775,6776)",arg_client_id).destroy_all
	end

	def self.get_assessment_validations_to_be_fixed(arg_client_id)
		where("client_id = ? and data_item_type in (6775,6776) and result = false",arg_client_id)
	end

	# def self.get_client_records(arg_client_id)
	# 	where("client_id = ?",arg_client_id)
	# end

	def self.get_data_validation_results(arg_application_id)
		application_validations = DataValidation.where("client_id in (select client_id from application_members where client_application_id = ?)",arg_application_id).order("client_id ASC")
	end

	def self.get_data_validation_results_to_be_corrected(arg_application_id)
		application_validations = DataValidation.where("result = false and client_id in (select client_id from application_members where client_application_id = ?)",arg_application_id).order("client_id ASC")
	end

	def self.get_program_unit_members_data_validation_results_to_be_corrected(arg_program_unit_id)
		application_validations = DataValidation.where("result = false and client_id in (select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id).order("client_id ASC")
	end

	def self.are_all_the_date_validations_complete(arg_id, arg_type)
		result = ""
		if arg_type == "APP"
			result = DataValidation.where("client_id in (select client_id from application_members where client_application_id = ?)",arg_id).count > 0
			result = result && (DataValidation.where("result = false and client_id in (select client_id from application_members where client_application_id = ?)",arg_id).count == 0)
		else
			result = DataValidation.where("client_id in (select client_id from program_unit_members where program_unit_id = ? )",arg_id).count > 0
			result = result && (DataValidation.where("result = false and client_id in (select client_id from program_unit_members where program_unit_id = ?)",arg_id).count == 0)
		end
		return result
	end
end
