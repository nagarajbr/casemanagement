task :generate_referal_maintainence_to_OCSE => :environment do

batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)

ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")

filename = "batch_results/daily/OCSE/OCSE_send/outbound/OCSE_" + ls_file_date.to_s + ".txt"
log_filename = "batch_results/daily/OCSE/OCSE_send/results/OCSE_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

path = File.join(Rails.root, filename )
log_path = File.join(Rails.root, log_filename )

# Create new file at a specified path.
file = File.new(path,"w+")
log_file = File.new(log_path,"w+")

l_extract_day = Date.today.strftime("%u")
if l_extract_day == 1
	l_extract_day = Date.today() - 2
	ls_extract_date = l_extract_day.strftime("%Y-%m-%d")
else
	ls_extract_date = Date.today.strftime("%Y-%m-%d")
end

log_file.puts("Begin daily OCSE process ")
log_file.puts("Extract date from: " + ls_extract_date.to_s)
l_nm_count = 0
l_np_count = 0
l_ca_count = 0
l_ac_count = 0
l_ce_count = 0
l_gc_count = 0
# write header
ocse_header_record = 'HR'
ocse_header_record = ocse_header_record + ' '.to_s.rjust(1,' ')
ocse_header_record = ocse_header_record + 'ARDWSTANF'
ocse_header_record = ocse_header_record + ' '.to_s.rjust(1,' ')
ocse_header_record = ocse_header_record + "#{Date.today.strftime("%Y%m%d")}"+"#{Time.now.strftime("%H%M")}"
ocse_header_record = ocse_header_record + ' '.to_s.rjust(10,' ') #673 spaces needed to get to 700
file.puts(ocse_header_record)

l_nm_child_without_ap = 0
l_nm_child_with_ap = 0
l_nm_adults = 0
l_nm_program_units =0
l_nm_program_units_members = 0
ls_error_cnt = 0
new_program_units = ProgramUnit.get_all_program_units_opened_from(ls_extract_date)
log_file.puts("*** Begin new member records to OCSE ***")
l_nm_program_units = new_program_units.size
if new_program_units.present?
	l_nm_program_units = new_program_units.size
	new_program_units.each do |referrals|
		# get prinary client id and store in variable
		l_primary_client_collection = ProgramUnitMember.get_primary_beneficiary(referrals.id)
		if l_primary_client_collection.present?
			l_primary_client_first = l_primary_client_collection.first
			l_primary_client_id = l_primary_client_first.client_id
		end
		l_secondary_client_id = ' '
		program_unit_members = ProgramUnitMember.sorted_program_unit_members(referrals.id)
		if program_unit_members.present?
			l_nm_program_units_members = program_unit_members.size
			# get secondary client id and store in variable
			program_unit_members.each do |members|
				if members.member_status == 4468 && members.primary_beneficiary == 'N'
					if Client.is_adult(members.client_id) == true
						l_secondary_client_id = members.client_id
					end
				end
			end
			# ready every member to write to NM record for OCSE
			program_unit_members.each do |members|
				if members.member_status == 4468 #active member
					step1 = Client.joins("LEFT OUTER JOIN entity_addresses ON (entity_addresses.entity_id = clients.id )
					LEFT OUTER JOIN addresses ON (entity_addresses.address_id = addresses.id and addresses.address_type = 4664)
					LEFT OUTER JOIN client_races on (client_races.client_id = clients.id)")
					step2 = step1.where("entity_addresses.entity_type = 6150 and clients.id = ?",members.client_id)
					if step2.present?
						clients_info =  step2.select("clients.*, addresses.*, client_races.*")
						if clients_info.present?
							client_first = clients_info.first
							ocse_record = 'NM'
							ocse_record = ocse_record + referrals.id.to_s.rjust(10,'0')
							ocse_record = ocse_record + client_first.client_id.to_s.rjust(10,'0')
							ocse_record = ocse_record + Date.today().to_s.rjust(10,'0')
							ocse_record = ocse_record + referrals.service_program_id.to_s.rjust(2,'0')
							ocse_record = ocse_record + client_first.first_name.to_s.ljust(15,' ')
							ocse_record = ocse_record + client_first.last_name.to_s.ljust(15,' ')
							ocse_record = ocse_record + client_first.middle_name.to_s.ljust(1,' ')
							ocse_record = ocse_record + client_first.ssn.to_s.ljust(9,'0')
							ocse_record = ocse_record + client_first.dob.to_s.ljust(10,' ')
							if client_first.gender.present?
								if client_first.gender == 4479 #Male
									ocse_record = ocse_record + 'M'
								else
									if client_first.gender == 4478 #Female
										ocse_record = ocse_record + 'F'
									else
										ocse_record = ocse_record + 'O'
									end
								end
							else
								ocse_record = ocse_record + 'U'
							end
							if client_first.race_id.present?
								ocse_record = ocse_record + client_first.race_id.to_s.rjust(5,'0')
							else
								ocse_record = ocse_record + '00000'
							end
							ocse_record = ocse_record + client_first.address_line1.to_s.ljust(30,' ')
							if client_first.address_line2.present?
								ocse_record = ocse_record + client_first.address_line2.to_s.ljust(30,' ')
							else
								ocse_record = ocse_record + ' '.to_s.ljust(30,' ')
							end
							ocse_record = ocse_record + client_first.city.to_s.ljust(20,' ')
							ocse_record = ocse_record + CodetableItem.get_short_description(client_first.state).to_s.ljust(15,' ')
							ocse_record = ocse_record + client_first.zip.to_s.rjust(5,'0')
							if client_first.zip_suffix.present?
								ocse_record = ocse_record + client_first.zip_suffix.to_s.rjust(4,'0')
							else
								ocse_record = ocse_record + ' '.to_s.rjust(4,' ')
							end
							ocse_record = ocse_record + client_first.county.to_s.rjust(5,'0')

							if Client.is_adult(client_first.client_id) == false
								# if children provide primary and secondary clients with their relationship
								ocse_record = ocse_record + l_primary_client_id.to_s.rjust(10,'0')
								l_relationship_collection = ClientRelationship.relationship_between_clients(l_primary_client_id,client_first.client_id)
								if l_relationship_collection.present?
									l_relationship = l_relationship_collection.first
									ocse_record = ocse_record + l_relationship.relationship_type.to_s.rjust(5,'0')
								else
									ocse_record = ocse_record + '0'.to_s.rjust(5,'0')
									log_file.puts("No relationship found between child #{client_first.client_id} and primary #{l_primary_client_id}")
									next
								end
								if l_secondary_client_id.present?
									ocse_record = ocse_record + l_secondary_client_id.to_s.rjust(10,'0')
									l_relationship_collection = ClientRelationship.relationship_between_clients(l_secondary_client_id,client_first.client_id)
									if l_relationship_collection.present?
										l_relationship = l_relationship_collection.first
										ocse_record = ocse_record + l_relationship.to_s.rjust(5,'0')
									else
										ocse_record = ocse_record + '0'.to_s.rjust(5,'0')
										log_file.puts("No relationship found between child #{client_first.client_id} and secondary #{l_primary_client_id}")
										next
									end
								else
									ocse_record = ocse_record + ' '.to_s.rjust(15,' ') # no secondary parent
								end
								ocse_temp_record = ocse_record
								# if absent parent with each child provide absent parent information
								step1 = ClientParentalRspability.joins("INNER JOIN client_relationships ON client_parental_rspabilities.client_relationship_id = client_relationships.id")
      							step2 = step1.where("client_relationships.from_client_id = ?",client_first.client_id)
      							client_rspabilities_collection = step2.select("client_relationships.*, client_parental_rspabilities.*")
      							if client_rspabilities_collection.present?
									client_rspabilities_collection.each do |absent_parent|
										ocse_record = ocse_temp_record
										step1 = Client.joins("INNER JOIN entity_addresses ON (entity_addresses.entity_id = clients.id and entity_addresses.entity_type = 6150)
											LEFT OUTER JOIN addresses ON (entity_addresses.address_id = addresses.id and addresses.address_type = 4664)
											LEFT OUTER JOIN client_races ON (client_races.client_id = clients.id)
											LEFT OUTER JOIN entity_phones ON (entity_phones.entity_id = clients.id)
											LEFT OUTER JOIN phones ON (entity_phones.phone_id = phones.id and phones.phone_type = 4661)")
										step2 = step1.where("clients.id = ?",absent_parent.to_client_id)
										step3 = step2.select("clients.*, addresses.*, client_races.*, phones.phone_number ")
										if step3.present?
											absent_parent_info = step3.first
											if absent_parent.parent_status == 6076 # absent parent
												ocse_record = ocse_record + absent_parent_info.client_id.to_s.rjust(10,'0')
												ocse_record = ocse_record + absent_parent.good_cause.to_s
												ocse_record = ocse_record + absent_parent.deprivation_code.to_s.rjust(5,'0')
												ocse_record = ocse_record + absent_parent_info.first_name.to_s.ljust(15,' ')
												ocse_record = ocse_record + absent_parent_info.last_name.to_s.ljust(15,' ')
												ocse_record = ocse_record + absent_parent_info.middle_name.to_s.ljust(1,' ')
												ocse_record = ocse_record + absent_parent_info.ssn.to_s.rjust(9,'0')
												ocse_record = ocse_record + absent_parent_info.dob.to_s
												if client_first.gender.present?
													if client_first.gender == 4479 #Male
														ocse_record = ocse_record + 'M'
													else
														if absent_parent_info.gender == 4478 #Female
															ocse_record = ocse_record + 'F'
														else
															ocse_record = ocse_record + 'O'
														end
													end
												else
													ocse_record = ocse_record + 'U'
												end
												if absent_parent_info.race_id.present?
													ocse_record = ocse_record + absent_parent_info.race_id.to_s.rjust(5,'0')
												else
													ocse_record = ocse_record + '00000'
												end
												ocse_record = ocse_record + absent_parent_info.address_line1.to_s.ljust(30,' ')
												if absent_parent_info.address_line2.present?
													ocse_record = ocse_record + absent_parent_info.address_line2.to_s.ljust(30,' ')
												else
													ocse_record = ocse_record + ' '.to_s.ljust(30,' ')
												end
												ocse_record = ocse_record + absent_parent_info.city.to_s.ljust(20,' ')
												ocse_record = ocse_record + CodetableItem.get_short_description(absent_parent_info.state).to_s.ljust(15,' ')
												ocse_record = ocse_record + absent_parent_info.zip.to_s.rjust(5,'0')
												if absent_parent_info.zip_suffix.present?
													ocse_record = ocse_record + absent_parent_info.zip_suffix.to_s.rjust(4,'0')
												else
													ocse_record = ocse_record + ' '.to_s.rjust(4,' ')
												end
												ocse_record = ocse_record + absent_parent_info.county.to_s.rjust(5,'0')
												ocse_record = ocse_record + absent_parent_info.phone_number.to_s.rjust(9,'0')
		    									step1 = Employment.joins("LEFT OUTER JOIN employers ON (employers.id = employments.employer_id)
        												LEFT OUTER JOIN entity_addresses ON (entity_addresses.entity_id = employers.id and entity_addresses.entity_type = 6152)
        												LEFT OUTER JOIN addresses ON (entity_addresses.address_id = addresses.id and addresses.address_type = 4665)")
    											step2 = step1.where("employments.client_id = ? ",absent_parent.to_client_id)
    											step3 = step2.select("addresses.*, employers.*").order("employments.effective_begin_date DESC")
												if step3.present?
													absent_parent_employment = step3.first
													ocse_record = ocse_record + absent_parent_employment.employer_name.to_s.ljust(30,' ')
													ocse_record = ocse_record + absent_parent_employment.address_line1.to_s.ljust(30,' ')
													if absent_parent_employment.address_line2.present?
														ocse_record = ocse_record + absent_parent_employment.address_line2.to_s.ljust(30,' ')
													else
														ocse_record = ocse_record + ' '.to_s.ljust(30,' ')
													end
													ocse_record = ocse_record + absent_parent_employment.city.to_s.ljust(15,' ')
													ocse_record = ocse_record + CodetableItem.get_short_description(absent_parent_employment.state).to_s.ljust(15,' ')
													ocse_record = ocse_record + absent_parent_employment.zip.to_s.rjust(5,'0')
													if absent_parent_employment.zip_suffix.present?
														ocse_record = ocse_record + absent_parent_employment.zip_suffix.to_s.rjust(4,'0')
													else
														ocse_record = ocse_record + ' '.to_s.rjust(4,' ')
													end
												else
													ocse_record = ocse_record + ' '.to_s.rjust(129,' ')
												end
												# insurance information - not currently captured
												ocse_record = ocse_record + ' '.to_s.rjust(30,' ')
												# Insurance policy - not currently captured
												ocse_record = ocse_record + ' '.to_s.rjust(30,' ')
												# Court order number
												ocse_record = ocse_record + absent_parent.court_order_number.to_s.ljust(10,' ')
												# court order date - not currently captured
												ocse_record = ocse_record + ' '.to_s.rjust(10,' ')
												# court ordered amount
												ocse_record = ocse_record + absent_parent.court_ordered_amount.to_s.rjust(12,'0')
												# Frequency of child support - not captured
												ocse_record = ocse_record + ' '.to_s.rjust(1,' ')
												# Pay to - not captured
												ocse_record = ocse_record + ' '.to_s.rjust(1,' ')
												# last payment date
												ocse_record = ocse_record + ' '.to_s.rjust(10,' ')
												# last payment amount
												ocse_record = ocse_record + ' '.to_s.rjust(12,'0')
												# filler
												ocse_record = ocse_record + ' '.to_s.rjust(15,' ')
												if ocse_record.length == 680
													file.puts(ocse_record)
													l_nm_count = l_nm_count + 1
													l_nm_child_with_ap = l_nm_child_with_ap + 1
													ClientParentalRspability.update(absent_parent.id, child_support_referral: 4579)
												else
													log_file.puts("Incorrect NM record lenght for client with ap : #{client_first.client_id.to_s}")
													log_file.puts("Incorrect NM record lenght: #{ocse_record.length}")
													log_file.puts(ocse_record)
												end
											else
												ocse_record = ocse_record + ' '.to_s.rjust(436,' ')
												if ocse_record.length == 680
													file.puts(ocse_record)
													l_nm_count = l_nm_count + 1
													l_nm_child_without_ap = l_nm_child_without_ap + 1
												else
													log_file.puts("Incorrect NM record lenght for client without ap : #{client_first.client_id.to_s}")
													log_file.puts("Incorrect NM record lenght: #{ocse_record.length}")
													log_file.puts(ocse_record)
												end
											end
										else
											log_file.puts("No parental responsibility client information found for client : #{client_first.client_id.to_s}")
											next
										end
									end
								else
									log_file.puts("No parental responsibility clients found for client : #{client_first.client_id.to_s}")
									next
								end
							else
								ocse_record = ocse_record + ' '.to_s.rjust(481,' ')
								if ocse_record.length == 680
									file.puts(ocse_record)
									l_nm_count = l_nm_count + 1
									l_nm_adults = l_nm_adults + 1
								else
									log_file.puts("Incorrect NM record lenght for adult client : #{client_first.client_id.to_s}")
									log_file.puts("Incorrect NM record lenght: #{ocse_record.length}")
									log_file.puts(ocse_record)
								end
							end
						else
							ls_error = 'Y'
							ls_error_cnt = ls_error_cnt + 1
							log_file.puts("No client found for program unit id : #{referrals.program_unit_id.to_s}")
						end
					end
				end
			end
		end
	end
	log_file.puts("NM program units read : " + l_nm_program_units.to_s)
	log_file.puts("NM program unit members read : " + l_nm_program_units_members.to_s)
	log_file.puts("NM adults written : " + l_nm_adults.to_s)
	log_file.puts("NM children without absent parent written : " + l_nm_child_without_ap.to_s)
	log_file.puts("NM children with absent parent written : " + l_nm_child_with_ap.to_s)
	log_file.puts("NM records written : " + l_nm_count.to_s)
else
	log_file.puts("No NM records selected ")
end
log_file.puts(" ")
log_file.puts("*** Begin member change records to OCSE***")
client_changed_collection = ProgramUnitMember.get_active_program_unit_members_with_resident_address_biographic_change
if client_changed_collection.present?
	client_changed_collection.each do |changed_client|
		if ProgramUnit.find_absent_parent_referal(changed_client.program_unit_id)
			ocse_record = 'CA'
			ocse_record = ocse_record + Date.today().to_s.rjust(10,'0')
			ocse_record = ocse_record + changed_client.program_unit_id.to_s.rjust(10,'0')
			ocse_record = ocse_record + changed_client.client_id.to_s.rjust(10,'0')
			puts "Name change: #{changed_client.name_chgd.to_s}"
			puts "DOB change: #{changed_client.dob_change.to_s}"
			if changed_client.name_chgd.to_s == 'Y'
				ocse_record = ocse_record + 'Y'
			else
				ocse_record = ocse_record + 'N'
			end
			if changed_client.dob_change.to_s == 'Y'
				ocse_record = ocse_record + 'Y'
			else
				ocse_record = ocse_record + 'N'
			end
			if changed_client.ssn_change.to_s == 'Y'
				ocse_record = ocse_record + 'Y'
			else
				ocse_record = ocse_record + 'N'
			end
			if changed_client.address_chgd.to_s == 'Y'
				ocse_record = ocse_record + 'Y'
			else
				ocse_record = ocse_record + 'N'
			end

			ocse_record = ocse_record + changed_client.first_name.to_s.ljust(15,' ')
			ocse_record = ocse_record + changed_client.last_name.to_s.ljust(15,' ')
			ocse_record = ocse_record + changed_client.middle_name.to_s.ljust(1,' ')
			ocse_record = ocse_record + changed_client.ssn.to_s.rjust(9,'0')
			ocse_record = ocse_record + changed_client.dob.to_s
			ocse_record = ocse_record + changed_client.address_line1.to_s.ljust(30,' ')
			if changed_client.address_line2.present?
				ocse_record = ocse_record + changed_client.address_line2.to_s.ljust(30,' ')
			else
				ocse_record = ocse_record + ' '.to_s.ljust(30,' ')
			end
			ocse_record = ocse_record + changed_client.city.to_s.ljust(20,' ')
			ocse_record = ocse_record + CodetableItem.get_short_description(changed_client.state).to_s.ljust(15,' ')
			ocse_record = ocse_record + changed_client.zip.to_s.rjust(5,'0')
			if changed_client.zip_suffix.present?
				ocse_record = ocse_record + changed_client.zip_suffix.to_s.rjust(4,'0')
			else
				ocse_record = ocse_record + ' '.to_s.rjust(4,' ')
			end
			ocse_record = ocse_record + changed_client.county.to_s.rjust(5,'0')
			ocse_record = ocse_record + ' '.to_s.rjust(485,' ')
			if ocse_record.length == 680
				file.puts(ocse_record)
				l_ca_count = l_ca_count + 1
			else
				log_file.puts("Incorrect CA record lenght for client : #{changed_client.client_id.to_s}")
				log_file.puts("Incorrect CA record lenght: #{ocse_record.length}")
				log_file.puts(ocse_record)
			end
		else
			log_file.puts("No absent parent refered in program unit: #{changed_client.program_unit_id.to_s}")
		end
	end
	log_file.puts("CA records written : " + l_ca_count.to_s)
else
	log_file.puts("No CA records selected ")
end

log_file.puts(" ")
log_file.puts("*** Begin AC records process ****")
#ls_extract_date = '2015-01-01'
program_unit_payments_collections = InStatePayment.where("updated_at >= ?", ls_extract_date)
if program_unit_payments_collections.present?
	program_unit_payments_collections.each do |payments|
		ocse_record = 'CA'
		ocse_record = ocse_record + Date.today().to_s.rjust(10,'0')
		ocse_record = ocse_record + payments.program_unit_id.to_s.rjust(10,'0')
		if payments.action_type == 6054 || payments.action_type == 6055
			ocse_record = ocse_record + '-'
		else
			ocse_record = ocse_record + '+'
		end
		ls_amt = sprintf("%.2f",payments.dollar_amount)
		ocse_record = ocse_record + ls_amt.to_s.rjust(9,'0')
		ls_pay_month = payments.payment_month.strftime("%Y%m").to_s
		ocse_record = ocse_record + ls_pay_month.to_s.rjust(6,'0')
		l_program_unit_member_count = 0
		l_adult_count = 0
		l_child_count = 0
		active_members_collection = ProgramUnitMember.get_active_program_unit_members(payments.program_unit_id)
		if active_members_collection.present?
			l_program_unit_member_count = active_members_collection.size
			active_members_collection.each do |members|
				if Client.is_adult(members.client_id) == false
					l_child_count = l_child_count + 1
				else
					l_adult_count = l_adult_count + 1
				end
			end
		else
			log_file.puts("No members in program unit: #{payments.program_unit_id.to_s}")
			next
		end
		ocse_record = ocse_record + l_adult_count.to_s
		ocse_record = ocse_record + l_child_count.to_s.rjust(2,'0')
		ocse_record = ocse_record + l_program_unit_member_count.to_s.rjust(2,'0')
		ocse_record = ocse_record + ' '.to_s.rjust(637,' ')
		if ocse_record.length == 680
			file.puts(ocse_record)
			l_ca_count = l_ca_count + 1
		else
			log_file.puts("Incorrect AC record lenght for program unit payment : #{payments.program_unit_id.to_s}")
			log_file.puts("Incorrect AC record lenght: #{ocse_record.length}")
			log_file.puts(ocse_record)
		end
	end
	log_file.puts("AC records written : " + l_ac_count.to_s)
else
	log_file.puts("No payments issued on : #{ls_extract_date.to_s}")
end

log_file.puts(" ")
log_file.puts("*** Begin CE records process ****")
member_closure_collection = ProgramUnitMember.where("member_status != 4468 and updated_at >= ? and updated_at != created_at", ls_extract_date)
if member_closure_collection.present?
	member_closure_collection.each do |closures|
		ocse_record = 'CE'
		ocse_record = ocse_record + Date.today().to_s.rjust(10,'0')
		ocse_record = ocse_record + closures.program_unit_id.to_s.rjust(10,'0')
		ocse_record = ocse_record + closures.client_id.to_s.rjust(10,'0')
		ocse_record = ocse_record + closures.updated_at.to_s.rjust(10,'0')
		# reason not available if individual member was closed
		if ocse_record.length == 680
			file.puts(ocse_record)
			l_ce_count = l_ce_count + 1
		else
			log_file.puts("Incorrect CE record lenght for program unit payment : #{payments.program_unit_id.to_s}")
			log_file.puts("Incorrect CE record lenght: #{ocse_record.length}")
		end
	end
	log_file.puts("CE records written : " + l_ce_count.to_s)
else
	log_file.puts("No members closed on #{ls_extract_date.to_s}")
end

end

