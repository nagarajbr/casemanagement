class EducationsController < AttopAncestorController
	def index
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@educations = @client.educations
		if session[:CLIENT_ASSESSMENT_ID].present?
			@assessment_id = session[:CLIENT_ASSESSMENT_ID]
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@client_assessment.current_step = "/ASSESSMENT/educations"
				session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
				@assessment_object = @client_assessment
				# clients_age = Client.get_age(session[:CLIENT_ID])
				# if clients_age != -1
				# 	li_adult_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
				# 	if clients_age < li_adult_age
				# 		flash[:alert] = "Assessment is required only for adults and minor parents, this client's age is #{clients_age}."
				# 	end
				# end
			end
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
		redirect_to_back

	end

	def new
		@client = Client.find(session[:CLIENT_ID])
		@menu = params[:menu]
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end


		@education = @client.educations.new
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		new_school_data()
		# @mappings = CodetableItem.item_list(66,"Application Disposition List")
		# 	@application_disposition_reasons = @mappings.inject({}) do |options, mapping|
		# 		if mapping.id == 6045
		# 			(options[6017] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
		# 		else
		# 			(options[6018] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
		# 		end
		# 	  options
		# 	end

		# @grade_level = CodetableItem.item_list(24,"High grade level")
		# @grade_level_grouped_options = @grade_level.inject({}) do |options, mapping|
		# 	(options[mapping.parent_id] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
		#   options
		# end
		populate_grouped_options_instance()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
		redirect_to_back
	end

	def create
		@client = Client.find(session[:CLIENT_ID])
		@menu = params[:menu]
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end

		@education = @client.educations.new(params_values)
		@school_types = CodetableItem.item_list(21,"school type")

		ls_msg = nil
		# check validations
		if  @education.valid?
			begin
	            ActiveRecord::Base.transaction do
					if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
				        common_action_argument_object.client_id = @client.id
				        common_action_argument_object.model_object = @education
				        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
				        common_action_argument_object.changed_attributes = @education.changed_attributes().keys
				        common_action_argument_object.is_a_new_record = @education.new_record?
				        common_action_argument_object.run_month = @education.effective_beg_date
				        @education.save!
						ls_msg = EventManagementService.process_event(common_action_argument_object)
					else
						ls_msg = @education.save! ? "SUCCESS" : "Cannot create education information"
					end
					if params[:notes].present?
						NotesService.save_notes(6150,session[:CLIENT_ID],6487,@education.id,params[:notes])
				    end
				end
			rescue => err
					# Rails.logger.debug("inside -create  ActiveRecord::Base.transaction rescue")
		          	error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","create",err,AuditModule.get_current_user.uid)
		          	ls_msg = "Failed to create Education information1 - for more details refer to Error ID: #{error_object.id}"
			end
			if ls_msg == "SUCCESS"
				# Manoj 10/02/2014
				if session[:NAVIGATE_FROM].blank?
					flash[:notice] = "Education information saved"
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
						redirect_to start_household_member_registration_wizard_path
					else
						redirect_to educations_path(@menu)
					end
				else
					# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
					navigate_back_to_called_page()
				end
	        else
				if session[:CLIENT_ASSESSMENT_ID].present?
					if session[:CLIENT_ASSESSMENT_ID].to_i != 0
						@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
						@assessment_object = @client_assessment
					end
				end
				populate_grouped_options_instance()
				flash.now[:alert] = ls_msg
				render :new
			end

		else
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
			new_school_data()
			populate_grouped_options_instance()
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving Education details"
		redirect_to_back
	end

	def show
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
			@education = Education.find(params[:education_id])
		else
			@education = Education.find(params[:id])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
		end

		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6487,@education.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Education record"
		redirect_to_back
	end

	def edit
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@school_types = CodetableItem.item_list(21,"school type")
		new_school_data()
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
			@education = Education.find(params[:education_id])
		else
			@education = Education.find(params[:id])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
		end
		populate_grouped_options_instance()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing Education details"
		redirect_to_back
	end

	def update
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@school_types = CodetableItem.item_list(21,"school type")
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
			@education = Education.find(params[:education_id])
		else
			@education = Education.find(params[:id])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
		end
		populate_grouped_options_instance()
		new_school_data()
		@education.assign_attributes(params_values)
		ls_msg = nil

		if @education.valid?
			begin
	            ActiveRecord::Base.transaction do
					if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
				        common_action_argument_object.client_id = @client.id
				        common_action_argument_object.model_object = @education
				        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
				        common_action_argument_object.changed_attributes = @education.changed_attributes().keys
				        common_action_argument_object.is_a_new_record = @education.new_record?
				        common_action_argument_object.run_month = @education.effective_beg_date
				        @education.save!
						ls_msg = EventManagementService.process_event(common_action_argument_object)
					else
						ls_msg = @education.save! ? "SUCCESS" : "Cannot update education information"
					end
					if params[:notes].present?
						NotesService.save_notes(6150,session[:CLIENT_ID],6487,@education.id,params[:notes])
				    end
				end
			rescue => err
		          	error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","update",err,AuditModule.get_current_user.uid)
		          	ls_msg = "Failed to update Education information - for more details refer to Error ID: #{error_object.id}"
			end
			if ls_msg == "SUCCESS"|| ls_msg.blank?
				flash[:notice] = "Education information saved"
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to educations_path(@menu)
				end
			else
				flash.now[:alert] = ls_msg
		 		render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Updating Education details"
		redirect_to_back
	end

	def destroy
		@client = Client.find(session[:CLIENT_ID])
		@menu = params[:menu]
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
			@education = Education.find(params[:education_id])
		else
			@education = Education.find(params[:id])
		end
		@education.destroy
		flash[:alert] = "Education information deleted"
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			redirect_to start_household_member_registration_wizard_path
		else
			redirect_to educations_path(@menu)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EducationsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting Education details"
		redirect_to_back
	end





	private

		  def params_values
		  	params.require(:education).permit(:school_type,:school_name,:attendance_type,:school_address_1,:school_address_2,:effective_beg_date,
		  		:effective_end_date,:expected_grad_date,:degree_obtained,:high_grade_level,:major_study,:effort)
		  end

		def populate_grouped_options_instance()
	  		@mappings = School.all.order("school_name asc")
			@grouped_options = @mappings.inject({}) do |options, mapping|
			  (options[mapping.school_type] ||= []) << [mapping.school_name, mapping.id]
			  options
			end
			#Rails.logger.debug("school grouped_options = #{@grouped_options.inspect}")
		end

		# Manoj 11/24/2015
	 #  	def set_hoh_data()
	 #  		li_member_id = params[:household_member_id].to_i
		# 	@household_member = HouseholdMember.find(li_member_id)
		# 	@household = Household.find(@household_member.household_id)
		# 	@head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		# end

		def new_school_data()
			@school_types = CodetableItem.item_list(21,"school type")
			@school_names = School.all
			# @grade_level = CodetableItem.item_list(24,"High grade level")
			# @grade_level_grouped_options = @grade_level.inject({}) do |options, mapping|
			# 	(options[mapping.parent_id] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
			#   	options
		 	#  end

		  	# Rails.logger.debug("@grade_level_grouped_options = #{@grade_level_grouped_options.inspect}")
		  	# fail
		  	@grade_level_grouped_options = {}
		  	# "Elementary"
		  	@grade_level_grouped_options[2192] = ("01".."05").to_a.map {|x|[x, CodetableItem.where("short_description = ?",x).first.id]}
		  	@grade_level_grouped_options[2192].unshift(["Pre School",6655])

		  	# "Middle School"
		  	@grade_level_grouped_options[2193] = ("04".."08").to_a.map {|x|[x, CodetableItem.where("short_description = ?",x).first.id]}

		  	# "Junior High School"
		  	@grade_level_grouped_options[2200] = ("06".."08").to_a.map {|x|[x, CodetableItem.where("short_description = ?",x).first.id]}
		  	# "High School"
		  	@grade_level_grouped_options[2194] = ("08".."12").to_a.map {|x|[x, CodetableItem.where("short_description = ?",x).first.id]}
		  	@grade_level_grouped_options[2194] << ["GED",2238]
		  	# 2198 "Adult School"
		  	# 2195 "College"
		  	# 2197 "Trade/Technical School"
		  	# 2196 "University"
		  	records = CodetableItem.item_list(24,"High grade level").where("id > 2225 and id not in (2233,6655,2236)")
		  	(2195..2198).map {|x| @grade_level_grouped_options[x] = records.map {|y| [y.short_description,y.id]}}

		  	# 2199 "Preschool"
		  	@grade_level_grouped_options[2199] = [["Pre School",6655]]
		end
end
