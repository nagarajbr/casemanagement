require "#{Rails.root}/lib/services/ebt_vendor_service.rb"
task :generate_maintainence_to_ebt_vendor => :environment do

batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)

ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")

filename = "batch_results/daily/EBT/EBT_maintainence/outbound/ebt_maint_" + ls_file_date.to_s + ".txt"
log_filename = "batch_results/daily/EBT/EBT_maintainence/results/ebt_maint_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

path = File.join(Rails.root, filename )
log_path = File.join(Rails.root, log_filename )

# Create new file at a specified path.
file = File.new(path,"w+")
log_file = File.new(log_path,"w+")

l_extract_day = Date.today.strftime("%u")
if l_extract_day == 1
	l_extract_day = Date.today() -2
	ls_extract_date = l_extract_day.strftime("%Y-%m-%d")
else
	ls_extract_date = Date.today.strftime("%Y-%m-%d")
end

log_file.puts("Begin daily maintainence to EBT vendor process ")
log_file.puts("Extract date from: " + ls_extract_date.to_s)
l_add_count = 0
l_change_count = 0
l_change_counta = 0
l_change_countb = 0
l_deactivate_count = 0
l_case_change_count = 0
l_add_case_count = 0
# write header
ebt_header_record = 'HC'
ebt_header_record = ebt_header_record + ' '.to_s.rjust(15,' ')
ebt_header_record = ebt_header_record + 'ARDWST'
ebt_header_record = ebt_header_record + 'CASE/CLIENT     '
ebt_header_record = ebt_header_record + "#{Date.today.strftime("%Y%m%d")}"+"#{Time.now.strftime("%H%M")}"
ebt_header_record = ebt_header_record + ' '.to_s.rjust(149,' ')
file.puts(ebt_header_record)


l_total = 0
# 6590;197;"Deactivating Program Unit Representative"
# 6589;197;"Adding Program Unit representative"
new_deactivates = NightlyBatchProcess.where("process_type = 6515 and reason = 6590 and entity_type = 6524 and client_id is not null and  processed is null and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# new_deactivates = ProgramUnitRepresentative.get_new_deactivates(ls_extract_date)
Rails.logger.debug("new_deactivates - #{new_deactivates.inspect}")
log_file.puts("")
log_file.puts("================================================")
log_file.puts("Begin deactivate records to EBT vendor process ")
if new_deactivates.present?
	l_error_cnt = 0
	l_bypass_closed = 0
	l_count = new_deactivates.size
	new_deactivates.each do |deactivates|
		l_program_unit_status = ProgramUnit.get_current_participation_status_value(deactivates.entity_id)
		client_id = EbtVendorService.get_account_from_program_unit(deactivates.entity_id)
		account_number = ProgramUnitRepresentative.get_account_if_exist(client_id,4381).first.account_number
		program_representative_object = ProgramUnitRepresentative.where("program_unit_id = ? and client_id = ? ",deactivates.entity_id, deactivates.client_id).order("id desc")
        if l_program_unit_status == 6043
			ebt_record = "D"
			ebt_record = ebt_record + account_number.to_s.rjust(12,'0')
			ebt_record = ebt_record + deactivates.entity_id.to_s.rjust(9,'0')
			if program_representative_object.first.representative_type == 4382 # Secondary 1
				ebt_record = ebt_record + "1C"
			else
				ebt_record = ebt_record + "2C" # Secondary 2
			end
			ebt_record = ebt_record + "Y"
			ebt_record = ebt_record + " ".ljust(175,' ')
			file.puts(ebt_record)
			l_deactivate_count = l_deactivate_count + 1
		else
			l_bypass_closed = l_bypass_closed + 1
		end
	end
	l_total = l_deactivate_count + l_bypass_closed
	if l_total != l_count
		log_file.puts("Deactivate records read for do not match deactivate records written and bypassed ")
	end
	log_file.puts("Deactivate records read : " + l_count.to_s)
	log_file.puts("Deactivate close records bypassed : " + l_bypass_closed.to_s)
	log_file.puts("Deactivate records written : " + l_deactivate_count.to_s)
else
	log_file.puts("No deactivate records selected ")
end
log_file.puts("================================================")
log_file.puts("")

l_total = 0
# add_to_accounts = ProgramUnitRepresentative.get_new_adds(ls_extract_date)
add_to_accounts = NightlyBatchProcess.where("process_type = 6515 and (reason = 6589 or reason is null)  and entity_type = 6524 and processed is null and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# add_to_accounts = NightlyBatchProcess.where("process_type = 6515 and reason = 6589 and entity_type = 6524 and processed is null ")
Rails.logger.debug("add_to_accounts - #{add_to_accounts.inspect}")
log_file.puts("")
log_file.puts("================================================")
log_file.puts("Begin add case number to account records to EBT vendor process ")
if add_to_accounts.present?
	l_error_cnt = 0
	l_bypass_new = 0
	l_count = add_to_accounts.size
	add_to_accounts.each do |accounts|
		client_id = EbtVendorService.get_account_from_program_unit(accounts.entity_id)
		account_number = ProgramUnitRepresentative.get_account_if_exist(client_id.to_i,4381).first.account_number
		program_representative_object = ProgramUnitRepresentative.where("program_unit_id = ? and client_id = ? ",accounts.entity_id, accounts.client_id).order("id desc")
		if AccountNumber.used_existing_account?(account_number)
			ls_error = 'N'
			ebt_record = "N"
			ebt_record = ebt_record + account_number.to_s.rjust(12,'0')
			ebt_record = ebt_record + accounts.entity_id.to_s.rjust(9,'0')
			if program_representative_object.first.representative_type == 4381 # Primary
				ebt_record = ebt_record + "PC"
			else
				if accounts.representative_type == 4382 # Secondary 1
					ebt_record = ebt_record + "1C"
				else
					ebt_record = ebt_record + "2C" # Secondary 2
				end
			end
			ebt_record = ebt_record + accounts.updated_by.to_s.rjust(6,'0') # worker number
			program_unit_method = ProgramUnit.get_completed_program_units(accounts.entity_id)
			if program_unit_method.present?
				program_unit_first = program_unit_method.first
			else
				ls_error = 'Y'
				l_error_cnt = l_error_cnt + 1
				log_file.puts("No completed program unit found for program unit id : #{accounts.program_unit_id.to_s}")
			end
			ebt_record = ebt_record + program_unit_first.processing_location.to_s.truncate(3).rjust(3,'0')
			ebt_record = ebt_record + " ".ljust(167,' ')
			if ls_error == 'N'
				file.puts(ebt_record)
				l_add_case_count = l_add_case_count + 1
			end
		else
			l_bypass_new = l_bypass_new + 1
		end
	end
	l_total = l_add_case_count + l_bypass_new
	if l_total != l_count
		log_file.puts("Case add records read for do not match case add records written and bypassed ")
	end
	log_file.puts("Case add records read : " + l_count.to_s)
	log_file.puts("Case add records bypassed : " + l_bypass_new.to_s)
	log_file.puts("Case add records erred : " + l_error_cnt.to_s)
	log_file.puts("Case add records written : " + l_add_case_count.to_s)
else
	log_file.puts("No case add accounts added ")
end
log_file.puts("================================================")
log_file.puts("")

l_total = 0
# change_case = ProgramUnitRepresentative.get_new_adds(ls_extract_date)
change_case = NightlyBatchProcess.where("process_type = 6515 and (reason = 6589 or reason is null) and entity_type = 6524 and processed is null and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# change_case = NightlyBatchProcess.where("process_type = 6515 and reason = 6589 and entity_type = 6524 and processed is null ")
Rails.logger.debug("change_case - #{change_case.inspect}")
log_file.puts("")
log_file.puts("================================================")
log_file.puts("Begin change case number to account records to EBT vendor process ")
if change_case.present?
	l_error_cnt = 0
	l_bypass_new = 0
	l_count = change_case.size
	change_case.each do |accounts|
		client_id = EbtVendorService.get_account_from_program_unit(accounts.entity_id)
		account_number = ProgramUnitRepresentative.get_account_if_exist(client_id.to_i,4381).first.account_number
		program_representative_object = ProgramUnitRepresentative.where("program_unit_id = ? and client_id = ? ",accounts.entity_id, accounts.client_id).order("id desc")
		if AccountNumber.used_existing_account?(account_number)
			ls_error = 'N'
			ebt_record = "O"
			ebt_record = ebt_record + account_number.to_s.rjust(12,'0')
			ebt_record = ebt_record + accounts.entity_id.to_s.rjust(9,'0')
			# get prior program unit id
			l_old_program_unit_id = ProgramUnitRepresentative.get_prior_program_unit(account_number)
			ebt_record = ebt_record + l_old_program_unit_id.to_s.rjust(9,'0')
			ebt_record = ebt_record + " ".ljust(169,' ')
			if ls_error == 'N'
				file.puts(ebt_record)
				l_case_change_count = l_case_change_count + 1
			end
		else
			l_bypass_new = l_bypass_new + 1
		end
	end
	l_total = l_case_change_count + l_bypass_new
	if l_total != l_count
		log_file.puts("Case change records read for do not match case change records written and bypassed ")
	end
	log_file.puts("Case change records read : " + l_count.to_s)
	log_file.puts("Case change records bypassed : " + l_bypass_new.to_s)
	log_file.puts("Case change records erred : " + l_error_cnt.to_s)
	log_file.puts("Case change records written : " + l_case_change_count.to_s)
else
	log_file.puts("No case change accounts added ")
end
log_file.puts("================================================")
log_file.puts("")

# new_accounts = ProgramUnitRepresentative.get_new_adds(ls_extract_date)
new_accounts = NightlyBatchProcess.where("process_type = 6515 and (reason = 6589 or reason is null) and entity_type = 6524 and processed is null and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# new_accounts = NightlyBatchProcess.where("process_type = 6515 and reason = 6589 and entity_type = 6524 and processed is null ")
Rails.logger.debug("new_accounts - #{new_accounts.inspect}")
log_file.puts("")
log_file.puts("================================================")
log_file.puts("Begin add records to EBT vendor process ")
if new_accounts.present?
	l_error_cnt = 0
	l_bypass_used = 0
	l_count = new_accounts.size
	new_accounts.each do |accounts|
		client_id = EbtVendorService.get_account_from_program_unit(accounts.entity_id)
		account_number = ProgramUnitRepresentative.get_account_if_exist(client_id.to_i,4381).first.account_number
		program_representative_object = ProgramUnitRepresentative.where("program_unit_id = ? and client_id = ? ",accounts.entity_id, accounts.client_id).order("id desc")
		if AccountNumber.used_existing_account?(account_number)
			change_type = 'C'
			update_records = EbtVendorService.populate_ebt_add_change_records(change_type,accounts)
			if update_records[1].present?
				log_file.puts(update_records[1])
				l_error_cnt = l_error_cnt + 1
			else
				file.puts(update_records[2])
				l_change_counta = l_change_counta + 1
			end
		else
			change_type = 'A'
			update_records = EbtVendorService.populate_ebt_add_change_records(change_type,accounts)
			if update_records[1].present?
				log_file.puts(update_records[1])
				l_error_cnt = l_error_cnt + 1
			else
				file.puts(update_records[2])
				l_add_count = l_add_count + 1
			end
		end
	end
	l_total = l_add_count + l_change_counta
	if l_total != l_count
		log_file.puts("Add records read for do not match add/change records written ")
	end
	log_file.puts("Add records read : " + l_count.to_s)
	log_file.puts("Add records erred : " + l_error_cnt.to_s)
	log_file.puts("Change records written : " + l_change_counta.to_s)
	log_file.puts("Add records written : " + l_add_count.to_s)
else
	log_file.puts("No new accounts added ")
end
log_file.puts("================================================")
log_file.puts("")

# new_changes = ProgramUnitRepresentative.get_biographic_and_address_changes(ls_extract_date)
new_changes = NightlyBatchProcess.where("process_type = 6515 and reason is null and entity_type = 6150 and processed is null and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# new_changes = NightlyBatchProcess.where("process_type = 6515 and reason is null and entity_type = 6150 and processed is null ")
Rails.logger.debug("new_changes - #{new_changes.inspect}")
log_file.puts("")
log_file.puts("================================================")
log_file.puts("Begin change records to EBT vendor process ")
if new_changes.present?
	l_error_cnt = 0
	l_count = new_changes.size
	new_changes.each do |changes|
		Rails.logger.debug("changes - #{changes.inspect}")
		change_type = 'C'
		update_records = EbtVendorService.populate_ebt_add_change_records(change_type,changes)
		if update_records[1].present?
			log_file.puts(update_records[1])
			l_error_cnt = l_error_cnt + 1
		else
			file.puts(update_records[2])
			l_change_countb = l_change_countb + 1
		end
	end
	if l_change_countb != l_count
		log_file.puts("Change records read for do not match change records written ")
	end
	log_file.puts("Change records read : " + l_count.to_s)
	log_file.puts("Change records erred : " + l_error_cnt.to_s)
	log_file.puts("Change records written : " + l_change_countb.to_s)
else
	log_file.puts("No change records selected ")
end
log_file.puts("================================================")
log_file.puts("")

ebt_trailer_record = 'TB'
l_change_count = l_change_counta + l_change_countb
l_add_and_change_count = l_add_count + l_change_count
ebt_trailer_record = ebt_trailer_record + l_add_and_change_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + l_add_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + l_change_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + l_deactivate_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + '0'.to_s.rjust(9,'0') # client change not required
ebt_trailer_record = ebt_trailer_record + '0'.to_s.rjust(27,'0') # direct deposit information not used anymore
ebt_trailer_record = ebt_trailer_record + l_add_case_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + l_case_change_count.to_s.rjust(9,'0')
ebt_trailer_record = ebt_trailer_record + '0'.to_s.rjust(9,'0') # Transfers not applicable anymore
ebt_trailer_record = ebt_trailer_record + ' '.to_s.rjust(99,' ')
file.write(ebt_trailer_record)
log_file.puts("End maintenence records to EBT vendor process ")
log_file.close
file.close
end

