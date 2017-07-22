class ImmunizationsController < AttopAncestorController
# 	#  Author : Manoj Patil
# 	# Date : 08/16/2014
# 	# Description : This screen does not follow normal pattern. follows PHONE page pattern
# 	# vaccinations are sorted by number of months since DOB , the vaccinationations needs to be given.
# 	# follow -phones MVC pattern.


# 	# Date required is not a field in the table. It will be computed based on DOB.
# 	# It needs to be computed always.
# 	# Used in Show and edit actions.
# 	# 1.


# 	# 2.
# 	def show
# 		# Rule 1: If client is not selected, show client selection button.
# 		# Rule 2 : check if DOB is populated for client, since Date required is calculated based on DOB and
# 		#          vaccinations are administered based on number of months child completed, so DOB is required to proceed with this page.
# 		# Rule 3 : All vaccinations should be showed - for records from Database- Date administered will be populated .
# 		#                                             - for records which need to inserted Date administeted will be blank.
# 		# Rule 4 : If No vaccinations are found show New button.
# 		if session[:CLIENT_ID].present?
# 			@client = Client.find(session[:CLIENT_ID])

# 			dob = @client.dob
# 			if dob.present?
# 				# immunization records from database.
# 				#  sort by vaccination type - hence sort by months - earliest vaccination to be administered comes first.
# 				@immunizations_database = @client.immunizations.order('vaccine_type')
# 				if @immunizations_database.count > 0
# 					# populate - virtual attribute date required.
# 					populate_date_required_db_records()
# 					# now 19 immunization records are available in view -
# 					vaccinations_array = SystemParam.param_values_list(2,"Vaccination List").to_a
# 					total_number_of_vaccinations = vaccinations_array.size

# 					if @immunizations_database.count == total_number_of_vaccinations
# 					# If 19 immunizations are in database - All is well proceed to show Page.
# 						@immunizations = @client.immunizations
# 					else
# 						# 19 immunization records not found for client - create 19 immunization records - merge with data from database.
# 						build_immunization_records()
# 						# Merge database record with in memory record
# 						@immunizations = []
# 						@match_found_object = nil
# 						lb_match_found = false

# 						@immunizations_new.each do |l_outer|
# 							@immunizations_database.each do |l_inner|
# 								# we are dealing with same client- Client ID and vaccination Type combination is unique.
# 								if l_inner.vaccine_type == l_outer["vaccine_type"]
# 									@match_found_object = l_inner
# 									lb_match_found = true
# 								end
# 								break if lb_match_found
# 							end # end of l_inner
# 							if lb_match_found == true
# 								# Populate final @ immunizations object which will have database + in memory merged phone objects
# 								@immunizations << @match_found_object
# 								lb_match_found = false
# 							else
# 								# Populate final @ immunizations object which will have database + in memory merged phone objects
# 								@immunizations << l_outer
# 							end
# 						end # end of l_outer

# 					end #end of if @immunizations_database.count == 19
# 				else
# 					@immunizations = @immunizations_database
# 					# show page will tell No immunization records found and New button.
# 				end

# 			end
# 		end
# 		rescue => err
# 			error_object = CommonUtil.write_to_attop_error_log_table("ImmunizationsController","show",err,current_user.uid)
# 			flash[:alert] = "Error ID: #{error_object.id} - attempted to show immunization details."
# 			redirect_to_back
# 	end





# 	def new
# 		build_immunization_records_for_create()
# 		rescue => err
# 			error_object = CommonUtil.write_to_attop_error_log_table("ImmunizationsController","new",err,current_user.uid)
# 			flash[:alert] = "Error ID: #{error_object.id} - attempted to create new immunization details."
# 			redirect_to_back
# 	end

# 	def create

# 		 @client = Client.find(session[:CLIENT_ID])

# 		#  Now in system param 19 < system param> vaccination records can be there at max.

# 		# {"utf8"=>"?",
# 		#  "authenticity_token"=>"CS3VVQfvDTjXSsjALCYtu2P/oXNnQpMWLoy0yHdkuhM=",
# 		#  "immunizations"=>[
# 							# {"provider_id"=>"",
# 							#  "date_required"=>"",
# 							#  "date_administered"=>"2014-01-01",
# 							#  "vaccine_type"=>"3",
# 							#  "created_by"=>"21",
# 							#  "updated_by"=>"21"
# 							# },
# 							#  {"provider_id"=>"",
# 							#  "date_required"=>"",
# 							#  "date_administered"=>"",
# 							#  "vaccine_type"=>"7",
# 							#  "created_by"=>"21",
# 							#  "updated_by"=>"21"
# 							# }
# 		#  ],
# 		#  "commit"=>"Save"
# 		# }
# 		l_params = immunization_params
# 		# filter params with not null date administered only.
# 		l_params_to_be_processed = l_params.reject{|p| p["date_administered"].empty?}
# 		# Create passing Array - errored records are present in @immunizations.
# 		@immunizations = Immunization.create(l_params_to_be_processed).reject { |p| p.errors.empty? }

# 		if @immunizations.present?
# 			@client.exempt_from_immunization = params[:exempt_from_immunization]
# 			# Only error records will be present - since we are rejecting good records.
# 			render :new
# 		else
# 			# Immunization objects saved.
# 			# Save Exempt from Immunization field in Clients Table.
# 			@client.exempt_from_immunization = params[:exempt_from_immunization]
# 			@client.save()

# 			flash[:notice] = "Immunization records created successfully."
# 			redirect_to show_immunizations_path
# 		end
#      rescue => err
# 			error_object = CommonUtil.write_to_attop_error_log_table("ImmunizationsController","create",err,current_user.uid)
# 			flash[:alert] = "Error ID: #{error_object.id} - attempted to create new immunization details."
# 			redirect_to_back
# 	end


# 	def edit
# 	# Decription : Edit page has to show all Immunization records .
# 		# If Immunization record found in the database show the existing data.
# 		# If Immunization record is not found - create the Immunization record in memory and show it.
# 		# User should be able to Modify existing Immunization number, Add Immunization
# 		# If they clear the Immunization date administered - It needs to delete that Immunization record.


# 	if session[:CLIENT_ID].present?
# 			@client = Client.find(session[:CLIENT_ID])


# 			# immunization records from database.
# 			@immunizations_database = @client.immunizations.order('vaccine_type')
# 			populate_date_required_db_records()
# 			# 19 immunization records should be available to edit.
# 			# logger.debug "@phones_current- count inspect =  #{@phones_current.count.inspect}"
# 			vaccinations_array = SystemParam.param_values_list(2,"Vaccination List").to_a
# 			total_number_of_vaccinations = vaccinations_array.size

# 		if @immunizations_database.count == total_number_of_vaccinations
# 				# If 19 immunizations are in database - All is well proceed to Edit Page.
# 				@immunizations = @client.immunizations
# 		else
# 				#19 immunization records not found for client - create 19 19 immunizations records - merge with data from database.
# 				build_immunization_records()
# 				# Merge database record with in memory record
# 				@immunizations = []
# 				@match_found_object = nil
# 				lb_match_found = false

# 			@immunizations_new.each do |l_outer|
# 				@immunizations_database.each do |l_inner|
# 					# we are dealing with same client- Client ID and vaccine_type combination is unique.
# 					if l_inner.vaccine_type == l_outer["vaccine_type"]
# 						@match_found_object = l_inner
# 						lb_match_found = true
# 					end
# 					break if lb_match_found
# 				end # end of l_inner
# 				if lb_match_found == true
# 					# Populate final @immunizations object which will have database + in memory merged phone objects
# 					@immunizations << @match_found_object
# 					lb_match_found = false
# 				else
# 					# Populate final @immunizations object which will have database + in memory merged phone objects
# 					@immunizations << l_outer
# 				end
# 			end # end of l_outer

# 		end #end of if @immunizations_database.count == 19

# 	end # end of session[:CLIENT_ID].present
#    rescue => err
# 			error_object = CommonUtil.write_to_attop_error_log_table("ImmunizationsController","edit",err,current_user.uid)
# 			flash[:alert] = "Error ID: #{error_object.id} - attempted to edit immunization details."
# 			redirect_to_back
# end # end of def edit


# def update


# 		# This is How params hash is - do insert/update/delete operation based on data.
# 		# Description : Multiple records are inserted/updated by providing Array of Hash to Update/Create
# 		# Active record methods.

# 		# EXAMPLE OF INCOMING PARAMS
# 		# {"utf8"=>"?",
# 		#  "_method"=>"put",
# 		#  "authenticity_token"=>"qGEFalthXt6FAa0lAvkFla95z5RZ2JN7HQash4agaTU=",
# 		#  "phones"=>{"19"=>	{"number"=>"5015884057",   # MNP -UPDATE OPERATION
# 		# 					 "client_id"=>"5",
# 		# 				 	"phone_type"=>"4661",
# 		# 				 	"created_by"=>"1",
# 		# 				 	"updated_by"=>"1"
# 		# 				 	},
# 		# 			 "-2"=>{"number"=>"5017658149",      # MNP -INSERT OPERATION
# 		# 			 "client_id"=>"5",
# 		# 			 "phone_type"=>"4663",
# 		# 			 "created_by"=>"1",
# 		# 			 "updated_by"=>"1"
# 		# 			 },
# 		# 			 "21"=>{"number"=>"",   # MNP -DELETE OPERATION
# 		# 			 "extension"=>"22222",
# 		# 			 "client_id"=>"5",
# 		# 			 "phone_type"=>"4662",
# 		# 			 "created_by"=>"1",
# 		# 			 "updated_by"=>"1"}
# 		# 			 },
# 		#  "commit"=>"Save"}


# 		@client = Client.find(session[:CLIENT_ID])
# 		# get the params
# 		l_params = params[:immunizations]
# 		l_insert_array = Array.new
# 		l_update_hash = Hash.new

# 		#  extract - update key/value pairs and Insert Key/value pairs
# 		l_params.each do |l_immunization|

# 			#insert hash
# 			# first index stores Key.
# 			# I have set ID as less than 0 to indicate they are not records from DB.

# 			if l_immunization[0].to_i < 1
# 				# second element is Hash
# 				l_h = l_immunization[1]
# 				if l_h["date_administered"].present?
# 					l_insert_array << l_immunization[1]
# 					# expected output which will passed to create method to create multiple records.
# 					#[ {number:"1234",client_id:"1" },{number:"1234",client_id:"1" } ]
# 				end
# 			else
# 				#update hash
# 				l_hash = l_immunization[1]
# 				if l_hash["date_administered"].present?
# 					# Assigning Value to the Key.
# 					# l_update_hash will become array - as we add more key value/pairs.
# 					l_update_hash["#{l_immunization[0]}"] = l_hash
# 					# expected output
# 					#["19"=> {"number"=>"5015884057","client_id"=>"5"}
# 		# 			  "20"=> {"number"=>"5011234567","client_id"=>"5"}
# 	    #            ]
# 				else
# 					# DElete operation - if user clears date administered.
# 					p_delete = Immunization.find(l_immunization[0].to_i)
# 					p_delete.destroy
# 				end
# 			end
# 		end   # end of l_params.each do
# 		# deciding what record to update or insert
# 		lb_errors_found = false
# 		# UPDATE multiple records
# 		# Only Error records are stored in the Object -to go back to Edit page-
# 		# Errors are shown per record- we are dealing with one object at a time.
# 		#  UPDATE
# 		@immunizations = Immunization.update(l_update_hash.keys,l_update_hash.values).reject { |p| p.errors.empty? }
# 		#  array to capture -update errors and insert error objects.
# 		@immuninizations_errors = []
# 		 # update errors found ?
# 		if  @immunizations.present?
# 			# only error records here since we are rejecting good records.
# 			@immunizations.each do |l_ph|
# 				@immuninizations_errors << l_ph
# 			end
# 			lb_errors_found = true
# 		end

# 		#  insert
# 		immunizations_array = Immunization.create(l_insert_array)
# 		immunizations_array.each do |l_ph|
# 		# setting to -ve value to tell I have to insert these records - and so it becomes Hash of hashes - instead of Array.
#  			if l_ph.errors.full_messages.present?
#  				# Capture insert errors.
# 				# @immunizations << l_ph
# 				#  set the id to -ve number  so that array will not be returned and hash will be returned- and -ve number means insertion in UPDATE action.
# 				l_ph.id = l_ph.vaccine_type * (-1)
# 				@immuninizations_errors << l_ph
# 				lb_errors_found = true
# 			end
# 		end

# 		if lb_errors_found == true
# 			# final object expected from view template will be populated with insert & update error objects.
# 			@immunizations = Array.new
# 			@immuninizations_errors.each do |l_im|
# 				# populate virtual field - date required.
# 				l_vaccination_type = l_im.vaccine_type
# 				l_dt_required = Immunization.compute_date_required(@client.dob,l_vaccination_type)
# 				l_im.date_required = l_dt_required
# 				@immunizations << l_im
# 			end
# 			render :edit
# 		else
# 			# Save Exempt from Immunization in clients table
# 			@client.exempt_from_immunization = params[:client][:exempt_from_immunization]
# 			@client.save()

# 			flash[:notice] = "Immunization information saved successfully."
# 			redirect_to show_immunizations_url
# 		end
# 		rescue => err
# 			error_object = CommonUtil.write_to_attop_error_log_table("ImmunizationsController","update",err,current_user.uid)
# 			flash[:alert] = "Error ID: #{error_object.id} - attempted to save immunization details."
# 			redirect_to_back
# end
# private

# # Allowing Arrays through STRONG PARAMETER
# #   	[{number:"1234",client_id:"11"},{{number:"1235",client_id:"11"}},{{number:"1444",client_id:"11"}}]
# #   	we have to reach the hash inside Array and permit them.
# 	  	 def immunization_params
# 		  params.require(:immunizations).map do |p|
# 		     ActionController::Parameters.new(p.to_hash).permit(:vaccine_type,:client_id,:provider_id,:created_by,:updated_by,:date_administered,:date_required)
# 		   end
# 		end

# 		# 3.
# 	# Build records depending on Number of vaccination records found in system param table - for EDit and show action
# 	def build_immunization_records
# 		 @client = Client.find(session[:CLIENT_ID])
# 		vaccinations_array = SystemParam.param_values_list(2,"Vaccination List").to_a
# 		total_number_of_vaccinations = vaccinations_array.size
# 		@immunizations_new  = Array.new(total_number_of_vaccinations) {@client.immunizations.build}
# 		# Get the vaccination type list from param tables.
# 		# get it an array

# 		li = 0
# 		# I am populating -ve numbers to indicate it is new record/insert operation in update action.
# 		lj = -1
# 		for arg_imm in @immunizations_new
# 			arg_imm.vaccine_type = vaccinations_array[li].id
# 			arg_imm.created_by = current_user.uid
# 			arg_imm.updated_by = current_user.uid
# 			# populate Date required based on the DOB of client.
# 			number_of_months = vaccinations_array[li].value.to_i
# 			#  add months to DOB and calculate Date required.
# 			#  Date required = Date of Birth + number_of_months
# 			dob = @client.dob
# 			l_dt_required = (number_of_months.months).since(dob)
# 			arg_imm.date_required = l_dt_required
# 			arg_imm.id = lj
# 			li = li + 1
# 			lj = lj -1
# 		end

# 	end

# 	def build_immunization_records_for_create
# 		@client = Client.find(session[:CLIENT_ID])
# 		vaccinations_array = SystemParam.param_values_list(2,"Vaccination List").to_a
# 		total_number_of_vaccinations = vaccinations_array.size
# 		@immunizations  = Array.new(total_number_of_vaccinations) {@client.immunizations.build}
# 		# Get the vaccination type list from param tables.
# 		# get it an array

# 		li = 0
# 		for arg_imm in @immunizations
# 			arg_imm.vaccine_type = vaccinations_array[li].id
# 			arg_imm.created_by = current_user.uid
# 			arg_imm.updated_by = current_user.uid
# 			# populate Date required based on the DOB of client.
# 			number_of_months = vaccinations_array[li].value.to_i
# 			#  add months to DOB and calculate Date required.
# 			#  Date required = Date of Birth + number_of_months
# 			dob = @client.dob
# 			l_dt_required = (number_of_months.months).since(dob)
# 			arg_imm.date_required = l_dt_required

# 			li = li + 1
# 		end
# 	end

# 	def populate_date_required_db_records()
# 		for arg_imzn in  @immunizations_database
# 			l_vaccination_type = arg_imzn.vaccine_type
# 			#  number of months is computed by vaccination type.
# 			l_dt_required = Immunization.compute_date_required(@client.dob,l_vaccination_type)
# 			# set date required field
# 			arg_imzn.date_required = l_dt_required

# 		end
# 	end

end