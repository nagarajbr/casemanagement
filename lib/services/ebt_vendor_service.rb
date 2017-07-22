class EbtVendorService
# Ashish Salgaponkar
# 01/30/2015
# Common functions for EBT vendor file creation.

	def self.populate_ebt_add_change_records(arg_ind,arg_collection)
		client_id = ""
		entity_id = ""
		if arg_collection["entity_type"] == 6524 #program unit
			client_id = arg_collection["client_id"].to_i
			entity_id = arg_collection["entity_id"].to_i
		elsif arg_collection["entity_type"] == 6150
             client_id = arg_collection["entity_id"].to_i
             program_unit_object = ProgramUnit.get_open_client_program_units("#{arg_collection["entity_id"].to_i}")
	    	 entity_id = program_unit_object.first.id
		end
		primary_client_id = EbtVendorService.get_account_from_program_unit(entity_id)
		account_number = ProgramUnitRepresentative.get_account_if_exist(primary_client_id.to_i,4381).first
		program_representative_object = ProgramUnitRepresentative.where("program_unit_id = ? and client_id = ? ",entity_id,client_id).order("id desc")
		# if arg_ind == 'A'
		# 	log_file.puts("Begin add records to EBT vendor process ")
		# else
		# 	log_file.puts("Begin change records to EBT vendor process ")
		# end
		# ls_write_count = 0
		# ls_error_cnt = 0
		# ls_count = arg_collection.size
		ls_error = 'N'
		ary = Array.new(2)
		#arg_collection.each do |arg_collection|
		client_method = Client.where("id = ?",client_id)
		if client_method.present?
			client_first = client_method.first
		else
			ls_error = 'Y'
			ary[1] = "No client found for program unit id : #{entity_id.to_s}"
		end
		program_unit_method = ProgramUnit.get_completed_program_units(entity_id)
		if program_unit_method.present?
			program_unit_first = program_unit_method.first
		else
			ls_error = 'Y'
			ary[1] = "No completed program unit found for program unit id : #{entity_id.to_s}"
		end
		address_method = Address.get_mailing_address(client_id, 6150)
		if address_method.present?
			address = address_method.first
		else
			ls_error = 'Y'
			ary[1] = "No mailing address found for client id: #{client_id.to_s}"
		end
		latest_run_method = ProgramWizard.get_latest_run_from_program_unit_id(entity_id)
		if latest_run_method.present?
			l_latest_run_id = latest_run_method.first.run_id
		else
			ls_error = 'Y'
			ary[1] = "No latest run found for client id: #{client_id.to_s}"
		end
		arg_month = 1
		program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(l_latest_run_id, arg_month)
		if program_benefit_detail_collection.present?
			program_benefit_detail = program_benefit_detail_collection.first
		else
			ls_error = 'Y'
			ary[1] = "No benefit detail found for program unit id: #{entity_id.to_s}"
		end
		if ls_error =='N'
			ls_state = CodetableItem.find_by("id = ?", address.state)
			if arg_ind == 'A'
				ebt_record = "A"
			else
				ebt_record = "C"
			end
			ebt_record = ebt_record + account_number.account_number.to_s.rjust(12,'0')
			ebt_record = ebt_record + entity_id.to_s.rjust(9,'0')
			if program_representative_object.first.representative_type == 4381 #primary
				ebt_record = ebt_record + "PC"
			else
				if program_representative_object.first.representative_type == 4382 # Secondary 1
					ebt_record = ebt_record + "1C"
				else
					ebt_record = ebt_record + "2C" # Secondary 2
				end
			end
			ebt_record = ebt_record + arg_collection[:updated_by].to_s.rjust(6,'0') # worker number
			ebt_record = ebt_record + program_unit_first.processing_location.to_s.truncate(3).rjust(3,'0')
			ebt_record = ebt_record + client_first.first_name.to_s.ljust(15,' ')
			if client_first.middle_name.present?
				ebt_record = ebt_record + client_first.middle_name.to_s.ljust(1,' ')
			else
				ebt_record = ebt_record + " "
			end
			ebt_record = ebt_record + client_first.last_name.to_s.ljust(20,' ')
			ebt_record = ebt_record + address.address_line1.to_s.ljust(30,' ')
			if address.address_line2?
				ebt_record = ebt_record + address.address_line2.to_s.ljust(30,' ')
			else
				ebt_record = ebt_record + ' '.to_s.ljust(30,' ')
			end
			ebt_record = ebt_record + address.city.to_s.ljust(20,' ')
			ebt_record = ebt_record + ls_state.short_description.to_s.ljust(2,' ')
			ebt_record = ebt_record + address.zip.to_s.ljust(5,' ')
			if 	address.zip_suffix?
				ebt_record = ebt_record + address.zip_suffix.to_s.ljust(4,' ')
			else
				ebt_record = ebt_record + ' '.ljust(4,' ')
			end
			ebt_record = ebt_record + client_first.dob.strftime("%Y%m%d").to_s.ljust(8,' ')
			ebt_record = ebt_record + client_first.ssn.to_s.ljust(9,' ')
			if program_benefit_detail.social_security_admin_amt.present?
				ebt_record = ebt_record + "Y" # SSA amount present
			else
				ebt_record = ebt_record + "N"
			end
			if arg_ind == 'A'
				ebt_record = ebt_record + "Y" # generate new card
				ebt_record = ebt_record + "Y" # generate pin
			else
				ebt_record = ebt_record + "N" # don't generate new card
				ebt_record = ebt_record + "N" # don't generate pin
			end
			ebt_record = ebt_record + "N" # drop ship for disaster - not reqd for TANF
			ebt_record = ebt_record + ' '.ljust(19,' ')
			ary[2] = ebt_record
		end
		puts ary[1]
		puts ary[2]
		return ary
	end



end

def self.get_account_from_program_unit(arg_program_unit_id)
	l_primary_client_id = ''
	primary_account_object = ProgramUnitRepresentative.get_representatives_from_program_units(arg_program_unit_id,4381)
	if primary_account_object.present?
		primary_accounts = primary_account_object.first
		l_primary_client_id = primary_accounts.client_id

	end
	return l_primary_client_id

end