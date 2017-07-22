# Manoj Patil
# 08/28/2015
# Description : ED Run reasons - child table of program_wizards
class ProgramWizardReason < ActiveRecord::Base
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



	def self.populate_ed_run_reasons(arg_run_id,arg_run_month)
		# ls_msg = "SUCCESS"
		# step1
		# Find the latest prgram_wizard_id bfor TODAY other than argument wizard_id.
		# li_program_unit_id = ProgramWizard.find(arg_program_wizard_id).program_unit_id
		program_wizards = ProgramWizard.where("run_id = ?",arg_run_id)
		program_wizard = program_wizards.first if program_wizards.present?
		if program_wizard.present?
			li_program_unit_id = program_wizard.program_unit_id
			program_wizard_collection = ProgramWizard.where("program_unit_id = ? and run_id != ? and date(created_at) = current_date",li_program_unit_id,program_wizard.id).order("id DESC")
			if 	program_wizard_collection.present?
				latest_program_wizard_object_for_today = program_wizard_collection.first
				# step2 - Get the program_wizard_reasons for latest_program_wizard_object_for_today
				program_wizard_reasons_collection = ProgramWizardReason.where("program_wizard_id = ?",latest_program_wizard_object_for_today.id) #previous run wizard id
				if program_wizard_reasons_collection.present?
					# step3
					# insert record into program_wizard_reasons table
							program_wizard_reasons_collection.each do |each_prior_reason|
								# existing_data_collection = ProgramWizardReason.where("program_wizard_id = ? and client_id = ? and reason = ?",each_prior_reason.program_wizard_id,each_prior_reason.client_id,each_prior_reason.reason)
								# if existing_data_collection.blank?
									program_wizard_reason_object = ProgramWizardReason.new
									program_wizard_reason_object.program_wizard_id = program_wizard.id # currently running wizard id
									program_wizard_reason_object.client_id = each_prior_reason.client_id
									program_wizard_reason_object.reason = each_prior_reason.reason
									program_wizard_reason_object.save
								# end

							end

				end
			end
			# step4 - any reason records found for the program_unit_id in nightly_batch_processes ?
			nightly_batch_processes_collection = NightlyBatchProcess.where("process_type = 6526
				                                                             and entity_type = 6524
				                                                              and entity_id = ?
				                                                                and reason is not null
				                                                                and Extract(month from run_month) = ?
				                                                                and EXTRACT(year FROM run_month) = ?",li_program_unit_id,arg_run_month.month,arg_run_month.year)



			# process type = ED
			# entity_type = Program unit
			if nightly_batch_processes_collection.present?

						nightly_batch_processes_collection.each do |each_reason_record|
							existing_data_collection = ProgramWizardReason.where("program_wizard_id = ? and client_id = ? and reason = ?",program_wizard.id,each_reason_record.client_id,each_reason_record.reason)
							if existing_data_collection.blank?
							# step5 insert record into program_wizard_reasons table
								program_wizard_reason_object = ProgramWizardReason.new
								program_wizard_reason_object.program_wizard_id = program_wizard.id
								program_wizard_reason_object.client_id = each_reason_record.client_id
								program_wizard_reason_object.reason = each_reason_record.reason
								program_wizard_reason_object.save
						    end

						end

				# success
				# step 6 - destroy the nightly_batch_processes_collection
				 nightly_batch_processes_collection.update_all("processed = 'Y'")
			end
		end

		# return ls_msg
	end



   def self.get_program_wizard_reasons(arg_program_wizard_id)
     	where("program_wizard_id = ? and (date(created_at) = current_date or date(updated_at) = current_date)", arg_program_wizard_id)

   end


end
