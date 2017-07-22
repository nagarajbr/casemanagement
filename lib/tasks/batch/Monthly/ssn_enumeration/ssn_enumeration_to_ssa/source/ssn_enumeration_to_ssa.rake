task :generate_ssn_enumeration_file_to_ssa => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    filename = "batch_results/monthly/ssn_enumeration/ssn_enumeration_to_ssa/outbound/ssn_to_ssa_extract"+ ".txt"
	log_filename = "batch_results/monthly/ssn_enumeration/ssn_enumeration_to_ssa/results/ssn_to_ssa_extract_log"+".txt"

	path = File.join(Rails.root, filename )
	log_path = File.join(Rails.root, log_filename )
	file = File.new(path,"w+")
	log_file = File.new(log_path,"w+")
	log_file.puts("Begin ssn enumeration to ssa")
	ls_extract_date = Date.today.strftime("%Y-%m-%d")
	log_file.puts("Extract date: " + ls_extract_date.to_s)
	ls_write = 0
	ls_count = 0
	ls_error_cnt = 0
	clients_ssn_enumeration_collection = NightlyBatchProcess.where("process_type = 6512 and processed is null ").select("distinct entity_id") # enumeration
	if clients_ssn_enumeration_collection.present?
		  ls_count = clients_ssn_enumeration_collection.size
		  clients_ssn_enumeration_collection.each do |each_client|
			      client = Client.find(each_client.entity_id)
		            if client.present?
		            	client_record = ''
		      	       client_record = client_record + client.ssn.to_s.strip[0,9].rjust(9,' ')#9s%
				       client_record = client_record + 'TPV'.ljust(3,' ')#3s%
				       client_record = client_record + '217'.ljust(3,' ')#3s%
				       client_record = client_record + client.last_name.to_s.strip[0,13].ljust(13,' ')#13s%
			           client_record = client_record + client.first_name.to_s.strip[0,10].ljust(10,' ')#10s%
			           client_record = client_record + client.middle_name.to_s.strip[0,7].ljust(7,' ')#7s%
			           client_record = client_record + client.dob.strftime("%m%d%Y").to_s.strip[0,8].rjust(8,' ')#8s%
			           client_record = client_record + ' '.ljust(49,' ')#49s%
			           client_record = client_record + '1'.ljust(21,' ')#20s%
			           client_record = client_record + '3ARA'.ljust(7,' ') + "\n"#3s%
			           if client_record.length != 132
					       file.write(client_record)
				           ls_write = ls_write + 1
					    else
					       log_file.write(client_record)
		                   ls_error_cnt = ls_error_cnt + 1
					    end
				   else
				   	   log_file.write(client_record)
		               ls_error_cnt = ls_error_cnt + 1

		           end
		           record_collection = NightlyBatchProcess.where("entity_id = #{each_client.entity_id} and process_type = 6512 ").update_all(processed: 'Y')
		  end
	end



	log_file.puts("Records read : " + ls_count.to_s)
	log_file.puts("Records erred : " + ls_error_cnt.to_s)
	log_file.puts("Records written : " + ls_write.to_s)
	#Close the file.
	file.close
	log_file.puts("End ssn enumeration to ssa")
	log_file.close

end