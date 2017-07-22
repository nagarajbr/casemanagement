class ClientCharacteristicsController < AttopAncestorController
	before_action :get_client

	def index
		if session[:CLIENT_ASSESSMENT_ID].present? && params[:menu] == "ASSESSMENT"
			if assessment_plan_not_required
				@assessment_id = session[:CLIENT_ASSESSMENT_ID].to_i
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
					@client_assessment.current_step = index_client_characteristic_path(@menu,@characteristic_type)
					session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
				end
			else
				if params[:menu] == "ASSESSMENT"
					session[:NAVIGATE_FROM] = index_client_characteristic_path(@menu,@characteristic_type)
					redirect_to assessment_activity_path
				end
			end
		end
		@client_characteristic = ClientCharacteristic.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	def new
		# fail
		# if params[:client_characteristic].present?
		# 	if params[:client_characteristic][:client_general_health_chalng_to_work_charcteristics_found_add_flag].present?
		# 		session["GENERAL_HEALTH_CHALNG_TO_WORK_CHAR_FOUND_ADD_FLAG"] = params[:client_characteristic][:client_general_health_chalng_to_work_charcteristics_found_add_flag]
		# 	end
		# end



		# @menu = params[:menu]
		@client_characteristic = ClientCharacteristic.new
		# if session["GENERAL_HEALTH_CHALNG_TO_WORK_CHAR_FOUND_ADD_FLAG"].present? && session["GENERAL_HEALTH_CHALNG_TO_WORK_CHAR_FOUND_ADD_FLAG"] == 'N'
		# 	@client_characteristic.characteristic_id = 5667 # Mandatory work characteristic
		# end
		populate_characteristic_drop_down(params[:characteristic_type])
		# Rails.logger.debug("@charcteristic_dropdown = #{@charcteristic_dropdown.inspect}")
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when attempting to new client characteristics."
		redirect_to_back
	end

	def create
		populate_characteristic_drop_down(params[:characteristic_type])
		# @menu = params[:menu]
		@client_characteristic = ClientCharacteristic.new(params_values)
		@client_characteristic.client_id = session[:CLIENT_ID]
		create_or_update(:new)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving Client Characteristics"
		redirect_to_back
	end



	def edit
		# @menu = params[:menu]
		populate_characteristic_drop_down(params[:characteristic_type])
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			@client_characteristic =  ClientCharacteristic.find(params[:client_characteristic_id])
		else
			@client_characteristic =  ClientCharacteristic.find(params[:id])
		end

		if @client_characteristic.characteristic_type == "WorkCharacteristic"
    		notes_type = 6478
    	elsif @client_characteristic.characteristic_type == "DisabilityCharacteristic"
    		notes_type = 6476
    	elsif @client_characteristic.characteristic_type == "SubstanceAbuseCharacteristic"
    		notes_type = 6477
    	elsif @client_characteristic.characteristic_type == "OtherCharacteristic"
    		notes_type = 6480
    	elsif @client_characteristic.characteristic_type == "LegalCharacteristic"
    		notes_type = 6479
    	elsif @client_characteristic.characteristic_type == "MentalCharacteristic"
    		notes_type = 5757
    	elsif @client_characteristic.characteristic_type == "DomesticViolenceCharacteristic"
    		notes_type = 5754
    	end

		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing client characteristics."
		redirect_to_back
	end

	def update
		# @menu = params[:menu]
		populate_characteristic_drop_down(params[:characteristic_type])
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			@client_characteristic =  ClientCharacteristic.find(params[:client_characteristic_id])
		else
			@client_characteristic =  ClientCharacteristic.find(params[:id])
		end
		@client_characteristic.assign_attributes(params_values)
		@client_characteristic.client_id = session[:CLIENT_ID]
		create_or_update(:edit)
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating client characteristics information."
		redirect_to_back
	end

	def show
		# @menu = params[:menu]
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			@client_characteristic =  ClientCharacteristic.find(params[:client_characteristic_id])
		else
			@client_characteristic =  ClientCharacteristic.find(params[:id])
		end

		if @client_characteristic.characteristic_type == "WorkCharacteristic"
    		notes_type = 6478
    	elsif @client_characteristic.characteristic_type == "DisabilityCharacteristic"
    		notes_type = 6476
    	elsif @client_characteristic.characteristic_type == "SubstanceAbuseCharacteristic"
    		notes_type = 6477
    	elsif @client_characteristic.characteristic_type == "OtherCharacteristic"
    		notes_type = 6480
    	elsif @client_characteristic.characteristic_type == "LegalCharacteristic"
    		notes_type = 6479
    	elsif @client_characteristic.characteristic_type == "MentalCharacteristic"
    		notes_type = 5757
    	elsif @client_characteristic.characteristic_type == "DomesticViolenceCharacteristic"
    		notes_type = 5754
    	end
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],notes_type,@client_characteristic.id)
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attemp to access invalid client characteristics record."
		redirect_to_back
	end

	def destroy
		# @menu = params[:menu]
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			@client_characteristic =  ClientCharacteristic.find(params[:client_characteristic_id])
		else
			@client_characteristic =  ClientCharacteristic.find(params[:id])
		end
		if @client_characteristic.characteristic_type == "WorkCharacteristic"
    		notes_type = 6478
    	elsif @client_characteristic.characteristic_type == "DisabilityCharacteristic"
    		notes_type = 6476
    	elsif @client_characteristic.characteristic_type == "SubstanceAbuseCharacteristic"
    		notes_type = 6477
    	elsif @client_characteristic.characteristic_type == "OtherCharacteristic"
    		notes_type = 6480
    	elsif @client_characteristic.characteristic_type == "LegalCharacteristic"
    		notes_type = 6479
    	elsif @client_characteristic.characteristic_type == "MentalCharacteristic"
    		notes_type = 5757
    	elsif @client_characteristic.characteristic_type == "DomesticViolenceCharacteristic"
    		notes_type = 5754
    	end
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],notes_type,@client_characteristic.id)
		ls_msg = ClientCharacteristicService.delete_client_characteristics(@client_characteristic,session[:CLIENT_ID],@notes)
		if ls_msg == "SUCCESS"
			flash[:notice] = "#{@characteristics_description} for client: #{@client.first_name}, #{@client.last_name} has been deleted! "
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				redirect_to start_household_characteristics_data_entry_wizard_path
			else
				redirect_to index_client_characteristic_path(@menu,@characteristic_type)
			end

		else
			flash[:notice] = ls_msg
			render :show
		end
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientCharacteristicsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attemp to delete client characteristics record."
		redirect_to_back
	end


	private

		def params_values
		  	params.require(:client_characteristic).permit(:characteristic_id,:start_date,:end_date)
	    end

	    def get_client
	    	@menu = params[:menu]
			if session[:CLIENT_ID].present?
			    cl_id = session[:CLIENT_ID]
			    @client = Client.find(cl_id)
			    case params[:characteristic_type]
					when 'disability'
						set_characteristic('DisabilityCharacteristic')
						@characteristic_table_name = "Disability Characteristics"
						@characteristics_description = "disability characteristics"
				    when 'substance_abuse'
				    	set_characteristic('SubstanceAbuseCharacteristic')
				    	@characteristic_table_name = "Substance Abuse Characteristics"
				    	@characteristics_description = "substance abuse characteristics"
				    when 'work'
				    	set_characteristic('WorkCharacteristic')
				    	@characteristic_table_name = "Work Characteristics"
				    	@characteristics_description = "work characteristics"
					when 'other'
						set_characteristic('OtherCharacteristic')
						@characteristic_table_name = "Other Characteristics"
						@characteristics_description = "other characteristics"
					when 'legal'
						set_characteristic('LegalCharacteristic')
						@characteristic_table_name = "Legal barriers characteristics"
						@characteristics_description = "legal barriers characteristics"
					when 'mental'
						set_characteristic('MentalCharacteristic')
						@characteristic_table_name = "Mental Health Characteristics"
						@characteristics_description = "mental health characteristics"
					when 'domestic'
						set_characteristic('DomesticViolenceCharacteristic')
						@characteristic_table_name = "Domestic Violence Characteristics"
						@characteristics_description = "domestic violence characteristics"
				end
				@characteristic_type = params[:characteristic_type]

				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					set_hoh_data()
				end
			end
	    end

	    def populate_characteristic_drop_down(arg_characteristic_type)
	    	case arg_characteristic_type
	    		when 'disability'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(114,'disability characteristics')
	    		when 'substance_abuse'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(115,'substance_abuse')
	    		when 'work'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(113,'work characteristics')
	    		when 'other'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(112,'other characteristics')
	    		when 'legal'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(206,'legal characteristics')
	    		when 'mental'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(204,'mental health characteristics')
	    		when 'domestic'
	    			@charcteristic_dropdown = CodetableItem.active_item_list(205,'domestic violence characteristics')
	    	end
	    end

	def set_characteristic(arg_table)
		# @characteristic_ids = arg_type
		@characteristic_table = arg_table
		# @characteristics_any = ClientCharacteristic.retrieve_characteristics(@client.id,@characteristic_table).count > 0
		@existing_characteristics = ClientCharacteristic.retrieve_characteristics(@client.id,@characteristic_table)
		if @existing_characteristics.blank?
			@client_characteristic = ClientCharacteristic.new
		end
	end

	def is_there_a_characteristic_overlap(arg_method_name)
		# Rails.logger.debug("params[:characteristic_type]characteristics = #{params[:characteristic_type].inspect}")
        characteristic_over_lap = false
		characteristic_id = params[:client_characteristic][:characteristic_id]
		if params[:client_characteristic][:end_date].blank?
			if params[:characteristic_type] == "work"
				characteristic_over_lap = @client_characteristic.is_there_a_record_with_work_characteristic_type_and_open_end_date("WorkCharacteristic", session[:CLIENT_ID])

				if characteristic_over_lap
					@client_characteristic.errors[:base] = "An open ended #{@characteristics_description} exists."
				end
			else
				characteristic_over_lap = @client_characteristic.is_there_a_record_with_same_characteristic_type_and_open_end_date(characteristic_id, session[:CLIENT_ID])
				if characteristic_over_lap
					@client_characteristic.errors[:base] = "An open ended #{@characteristics_description} of same type already exists."
				end
			end
		end

		unless characteristic_over_lap
			if params[:characteristic_type] == "work"
				same_characteristic_records = ClientCharacteristic.get_all_work_characteristic_records_for_the_client(session[:CLIENT_ID])
				if @client_characteristic.id.present?
					same_characteristic_records = same_characteristic_records.where("id != ?",@client_characteristic.id)
				end
			else
				same_characteristic_records = ClientCharacteristic.get_all_the_records_with_same_characteristic_id_for_the_client(characteristic_id, session[:CLIENT_ID])
				if @client_characteristic.id.present?
					same_characteristic_records = same_characteristic_records.where("id != ?",@client_characteristic.id)
				end
			end


			same_characteristic_records.each do |record|
				start_date = params[:client_characteristic][:start_date].to_date
				end_date = params[:client_characteristic][:end_date].present? ? params[:client_characteristic][:end_date].to_date : start_date
				if record.end_date.present?
					while start_date <= end_date
						if (record.start_date..record.end_date).cover?(start_date)
							@client_characteristic.errors[:characteristic_id] = "selected dates overlap."
							initialize_input_params_from_ui()
							characteristic_over_lap = true
							break
						end
						start_date = start_date + 1
					end
				else
					if end_date <= record.start_date
					else
					   @client_characteristic.errors[:characteristic_id] = "selected dates overlap."
						initialize_input_params_from_ui()
						characteristic_over_lap = true
					end
				end
				# record.end_date = record.end_date.present? ? record.end_date : record.start_date

				if characteristic_over_lap
					break
				end
			end
		end

		return characteristic_over_lap
	end

	def initialize_input_params_from_ui()
		# if session["GENERAL_HEALTH_CHALNG_TO_WORK_CHAR_FOUND_ADD_FLAG"] == 'N'
		# 	@client_characteristic.characteristic_id = 5667 # Mandatory work characteristic
		# else
			@client_characteristic.characteristic_id = params[:client_characteristic][:characteristic_id].to_i
		# end

		@client_characteristic.start_date = params[:client_characteristic][:start_date]
		@client_characteristic.end_date = params[:client_characteristic][:end_date]
	end

	def save_client_characteristic
		@client_characteristic.client_id = session[:CLIENT_ID]
		@client_characteristic.characteristic_type = @characteristic_table.to_s
		initialize_input_params_from_ui()
		# Rails.logger.debug("@client_characteristic = #{@client_characteristic.inspect}")

		return_object = ClientCharacteristicService.create_client_characteristics(@client_characteristic,session[:CLIENT_ID],params[:notes])
		# Rails.logger.debug("return_object = #{return_object.inspect}")
		return return_object
	end

	def create_or_update(arg_method_name)
		if params[:client_characteristic][:characteristic_id].present? && params[:client_characteristic][:start_date].present? && @client_characteristic.valid?
			# fail
			if is_there_a_characteristic_overlap(arg_method_name)
				initialize_input_params_from_ui()
				render arg_method_name
			else
				# fail
				result = save_client_characteristic
				if result.class.name == "String"
					@client = Client.find(session[:CLIENT_ID])
			         if session[:CLIENT_ASSESSMENT_ID].present?
				       if session[:CLIENT_ASSESSMENT_ID].to_i != 0
						    @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					        @assessment_object = @client_assessment
				       end
			         end
			        flash.now[:alert] = result
				    render arg_method_name
			  	else
			  		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			  			redirect_to start_household_characteristics_data_entry_wizard_path
			  		else
			  			if session[:NAVIGATE_FROM].blank?
			  			redirect_to index_client_characteristic_path(@menu,@characteristic_type), notice: "#{@characteristics_description} for client: #{@client.first_name}, #{@client.last_name} has been saved! "
				  		else
				  			# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
					  		navigate_back_to_called_page()
				  		end
			  		end
				end
			end
		else
			# fail
			params[:client_characteristic][:characteristic_id].present? ? "" : @client_characteristic.errors[:characteristic_id] = " type is required!"
			params[:client_characteristic][:start_date].present? ? "" : @client_characteristic.errors[:start_date] = "is required!"
			initialize_input_params_from_ui()
			render arg_method_name
		end
	end

	# def all_mandatory_attributes_are_present?
	# 	result = true
	# 	if params[:characteristic_type] == 'work'
	# 		if params[:client_characteristic]['start_date(1i)'].present? && params[:client_characteristic]['start_date(2i)'].present?
	# 			sd_month = params[:client_characteristic]['start_date(2i)'].to_i
	# 			sd_day = 1 # params[:client_characteristic]['start_date(3i)'].to_i
	# 			sd_year = params[:client_characteristic]['start_date(1i)'].to_i
	# 			params[:client_characteristic][:start_date] = Date.civil(sd_year,sd_month,sd_day)
	# 		else
	# 			result = false

	# 		end

	# 		if params[:client_characteristic]['end_date(1i)'].present? || params[:client_characteristic]['end_date(2i)'].present?
	# 			if params[:client_characteristic]['end_date(1i)'].present? && params[:client_characteristic]['end_date(2i)'].present?
	# 				sd_month = params[:client_characteristic]['end_date(2i)'].to_i
	# 				sd_day = 1 # params[:client_characteristic]['end_date(3i)'].to_i
	# 				sd_year = params[:client_characteristic]['end_date(1i)'].to_i
	# 				end_date = Date.civil(sd_year,sd_month,sd_day)
	# 				params[:client_characteristic][:end_date] = end_date.end_of_month
	# 			else
	# 				result = false
	# 				params[:client_characteristic][:end_date].present? ? "" : @client_characteristic.errors[:end_date] = "is required!"
	# 			end
	# 		end
	# 	else
	# 		result = params[:client_characteristic][:characteristic_id].present? && params[:client_characteristic][:start_date].present?
	# 	end
	# 	return result
	# end

	# Manoj 11/24/2015
  	def set_hoh_data()
  		li_member_id = params[:household_member_id].to_i
		@household_member = HouseholdMember.find(li_member_id)
		@household = Household.find(@household_member.household_id)
		# @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
	end
end