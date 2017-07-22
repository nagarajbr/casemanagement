task :generate_account_ebt => :environment do

batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)

ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")

log_filename = "batch_results/daily/EBT/EBT_maintainence/results/ebt_account_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

log_path = File.join(Rails.root, log_filename )

# Create new file at a specified path.
log_file = File.new(log_path,"w+")

l_extract_day = Date.today.strftime("%u")
if l_extract_day == 1
	l_extract_day = Date.today() -2
	ls_extract_date = l_extract_day.strftime("%Y-%m-%d")
else
	ls_extract_date = Date.today.strftime("%Y-%m-%d")
end

log_file.puts("Begin EBT account assignment process ")
log_file.puts("Extract date from: " + ls_extract_date.to_s)
ls_primary_count = 0
ls_secondary_count = 0
ls_primary_write_count = 0
ls_secondary_write_count = 0
ls_primary_error_cnt = 0
ls_secondary_error_cnt = 0
# 6762 -"EBT First Time Activation"
nightly_batch_processes_for_ed = NightlyBatchProcess.where("process_type = 6515 and processed is null and reason = 6762 and (date(created_at) >= ? or date(updated_at) >= ? )",ls_extract_date,ls_extract_date)
# nightly_batch_processes_for_ed = NightlyBatchProcess.where("process_type = 6515 and processed is null and entity_type = 6524 ")
Rails.logger.debug("nightly_batch_processes_for_ed = #{nightly_batch_processes_for_ed.inspect}")
ls_primary_count = nightly_batch_processes_for_ed.count
if nightly_batch_processes_for_ed.present?
	nightly_batch_processes_for_ed.each do |each_ebt_record|
		# Assign account numbers to primary of program unit
		#representative_type - primary 4381
		# client_id

	    primary_account_object = ProgramUnitRepresentative.get_representatives_from_program_units(each_ebt_record.entity_id,4381)
	    Rails.logger.debug("primary_account_object = #{primary_account_object.inspect}")
	    if primary_account_object.present?
	    	primary_accounts = primary_account_object.first
	       puts (" primary representative id: " + primary_accounts.id.to_s)
	       Rails.logger.debug("primary_accounts.id = #{primary_accounts.id.inspect}")
	       l_primary_client_id = primary_accounts.client_id
	       Rails.logger.debug("primary_accounts.client_id = #{primary_accounts.client_id.inspect}")
	       puts ("l_primary_client_id : " + l_primary_client_id.to_s)
	       primary_collection = ProgramUnitRepresentative.get_account_if_exist(l_primary_client_id,4381)
	       Rails.logger.debug("primary_collection = #{primary_collection.inspect}")
	       l_account_number = ''
	       	if primary_collection.present?
	       		Rails.logger.debug("-----------1")
	       		Rails.logger.debug("primary_collection1 = #{primary_collection.inspect}")
				primary = primary_collection.first
				puts (" primary representative id found: " + primary_accounts.id.to_s + " Account number: " + primary.account_number.to_s)
				#use existing account number
				Rails.logger.debug("primary1 = #{primary.inspect}")
				l_account_number = primary.account_number
		   	else
		   		Rails.logger.debug("-----------2")
				puts (" primary representative id not found : " + primary_accounts.id.to_s)
				# Rails.logger.debug("l_account_number1 = #{AccountNumber.get_ebt_account_number_next_value().inspect}")
				l_account_number = AccountNumber.get_ebt_account_number_next_value()
				Rails.logger.debug("l_account_number1 = #{l_account_number.inspect}")
		  	 end
		  	 Rails.logger.debug("l_account_number*** = #{l_account_number.inspect}")
			ls_message = AccountNumber.add_new(l_account_number, primary_accounts.id)
			Rails.logger.debug("ls_message*** = #{ls_message.inspect}")
			if ls_message == 'SUCCESS'
				ls_primary_write_count = ls_primary_write_count + 1
			elsif ls_message == "NEWRECORD"
                ls_primary_write_count = ls_primary_write_count + 1
			else
				ls_error = 'Y'
				ls_primary_error_cnt = ls_primary_error_cnt + 1
				log_file.puts("Error inserting primary id " + primary_accounts.id.to_s + "to accounts database : " + ls_message.to_s)
				next

			end
	    # Use account numbers of primary of program unit for secondary of program unit
		#representative_type secondary- 4382
		new_secondary_accounts = ProgramUnitRepresentative.get_representatives_from_program_units(each_ebt_record.entity_id,4382)
		Rails.logger.debug("new_secondary_accounts = #{new_secondary_accounts.inspect}")
		ls_secondary_count = new_secondary_accounts.count
		if new_secondary_accounts.present?
			new_secondary_accounts.each do |secondary_accounts|
				puts (" secondary representative id: " + secondary_accounts.id.to_s)
				ls_error = 'N'
				secondary_collection = ProgramUnitRepresentative.get_account_of_primary_of_program_unit(each_ebt_record.entity_id)
				if secondary_collection.present?
					secondary = secondary_collection.first
					puts (" secondary representative id found: " + secondary_accounts.id.to_s + " Account number: " + secondary.account_number.to_s)
					#use existing account number
					l_account_number = secondary.account_number
					ls_message = AccountNumber.add_new(l_account_number, secondary_accounts.id)
					if ls_message == 'SUCCESS'
						ls_secondary_write_count = ls_secondary_write_count + 1
					elsif ls_message == "NEWRECORD"
		                ls_secondary_write_count = ls_secondary_write_count + 1
					else
						ls_error = 'Y'
						ls_primary_error_cnt = ls_primary_error_cnt + 1
						log_file.puts("Error inserting primary id " + primary_accounts.id.to_s + "to accounts database : " + ls_message.to_s)
						next

					end
				else
					ls_error = 'Y'
					ls_secondary_error_cnt = ls_secondary_error_cnt + 1
					log_file.puts("Error primary not found for secondary id " + secondary_accounts.id.to_s)
					next
				end
			end
		else
			log_file.puts("No new secondary representatives found for program_unit #{each_ebt_record.entity_id}")
		end
	else
    	log_file.puts("No new primary representatives found for program_unit #{each_ebt_record.entity_id}")
    end

	end #nightly_batch_processes_for_ed.each do |each_ebt_record|
else


end#if nightly_batch_processes_for_ed.present?

	if ls_primary_write_count != ls_primary_count
		log_file.puts("Records read for primary do not match records written ")
	end
	log_file.puts("Primary records read : " + ls_primary_count.to_s)
	log_file.puts("Primary records erred : " + ls_primary_error_cnt.to_s)
	log_file.puts("Primary records written : " + ls_primary_write_count.to_s)

	if ls_secondary_write_count != ls_secondary_count
		log_file.puts("Records read for secondary do not match records written ")
	end
	log_file.puts("Secondary records read : " + ls_secondary_count.to_s)
	log_file.puts("Secondary records erred : " + ls_secondary_error_cnt.to_s)
	log_file.puts("Secondary records written : " + ls_secondary_write_count.to_s)

	log_file.puts("End EBT account assignment process ")
	log_file.close
end
