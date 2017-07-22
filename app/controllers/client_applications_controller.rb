	class ClientApplicationsController < AttopAncestorController
	respond_to :html

	# Author : Manoj Patil
	# Date : 09/05/2014
	# Description: APPLICATION WIZARD -CRUD operation for Model - ClientApplication AND Client Application Wizard.
	# Application Member and Client Relations with Primary Applicant are also captured in this controller.
	# All functionality needed for WIZARD are captured in one place for easy maintenance, rather than scattering
	# in different resources.

	#This Action is called from Applications Menu.
	def index
		# Application List for Focus Client
		# if session[:CLIENT_ID].present?
			# @client = Client.find(session[:CLIENT_ID])
		if	session[:HOUSEHOLD_ID].present? &&  session[:HOUSEHOLD_ID].to_i != 0
			@household = Household.find(session[:HOUSEHOLD_ID].to_i)
			# show applications focus client is involved in
			# @client_applications = ClientApplication.get_applications_list(@client.id).order("id DESC")
			@household_applications = ClientApplication.get_applications_for_household(@household.id)
			session[:APPLICATION_PROCESSING_STEP] = nil


		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","Index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	# Select Link on Applications Index will call this action to show the details of selected Application.
	def show
		objects_required_for_show(params[:application_id].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end


	def destroy_application_member
		# application_member table record- destroy
		@application_member = ApplicationMember.find(params[:id])
		@application_member.destroy
		flash[:alert] = "Member removed from this application."

		# make the application status incomplete.
		# client_application =ClientApplication.find(session[:APPLICATION_ID])
		# client_application.application_status = 5943
		# client_application.save
		# navigate_to_called_page_session()
		session[:APPLICATION_PROCESSING_STEP] = 'application_processing_second'
		redirect_to start_application_processing_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","destroy_application_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Application Member"
		redirect_to_back
	end




	# New Application link will call this action.
	def new_application_wizard_initialize

		@client = Client.find(session[:CLIENT_ID])
			# called from New Application button from Index page
			# session[:new_application_id] is needed to know what application ID created after step1.
			# session[:application_step] is needed to know what partial-step-page to open.
			session[:new_application_id] = session[:application_step] = session[:NAVIGATED_FROM] = nil
			session[:CALLED_FROM] = "WIZARD"
			redirect_to new_client_application_path

		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","new_application_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access new application."
		redirect_to_back
	end


	# Application Wizard -which will open different steps.
	def new

		@client = Client.find(session[:CLIENT_ID])

				# Description : All application creation WIZARD steps travel through new and create actions.
				# NEXT and BACK buttons go to create action - and create action processes and send it to new action
				# in new.html.erb all step partials are opened.
				session[:NAVIGATED_FROM] = nil
				# creating New Application by WIZARD
				# Multi step form - wizard
				#Initialise session[:application_step]
		      	if session[:application_step].blank?
		      	 	session[:application_step] = nil
		      	end

		      	# Populate instance variables for wizard step objects
		      	# step 1
		      	if session[:new_application_id].present?
		      		@edit_mode = true
		      		@display_text = "Editing"
		      		#  RETRIEVE Application object and application service program object
		      	 	@client_application = ClientApplication.find(session[:new_application_id].to_i)
		      	 	# Step 2
			      	@application_members = ApplicationMember.sorted_application_members_and_member_info(@client_application.id)
			      	# Step 3.
			      	primary_applicant_object = ApplicationMember.get_primary_applicant(session[:new_application_id].to_i)
			      	if primary_applicant_object.present?
			      		# virtual attribute storing Primary Applicant
			      		@client_application.self_client_id = primary_applicant_object.first.client_id
			      	end
			      	# Step 4
			      	# Client Relations
			       	 @client_relations = ClientRelationship.get_apllication_member_relationships(session[:new_application_id].to_i)
			   		if session[:application_step] == "client_application_fifth"
			   			@client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(@client_application.id)
		      			@client_application.current_step = session[:application_step]
			      	end
			      	@client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(@client_application.id)

			   	else
		      		@edit_mode = false
		      		@display_text = "Creating"
		      		@client_application = ClientApplication.new
		      	end

		      	#  @client_application.current_step is used in view template to show correct step page.
		      	@client_application.current_step = session[:application_step]

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back

	end


	# Application wizard - processing
	def create

		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.

		# Instantiate client_application object
		@client = Client.find(session[:CLIENT_ID])

  	 	@client_applications = ClientApplication.get_applications_list(@client.id).order("id DESC")
		# populate instance variables
		if session[:new_application_id].blank?
      	 	@client_application = ClientApplication.new
      	else
      	 	@client_application = ClientApplication.find(session[:new_application_id].to_i)
      	 	# Step 3.
			@application_members = ApplicationMember.sorted_application_members(@client_application.id)
			primary_applicant_object = ApplicationMember.get_primary_applicant(session[:new_application_id].to_i)
	      	if primary_applicant_object.present?
	      		@client_application.self_client_id = primary_applicant_object.first.client_id
	      	end
	      	@client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(@client_application.id)
	      	@client_relations = ClientRelationship.get_apllication_member_relationships(session[:new_application_id].to_i)
      	end

      	@client_application.current_step = session[:application_step]
      	 # manage steps
      	if params[:back_button].present?
      		 @client_application.previous_step
      	elsif @client_application.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @client_application.next_step
        end
       session[:application_step] = @client_application.current_step

         # what step to process?
		if @client_application.get_process_object == "client_application_first" && params[:next_button].present?
			# Application for the focus client
		 	local_params = params_first_step
		 	if session[:new_application_id].present?
		 		@client_application = ClientApplication.find( session[:new_application_id].to_i)
		 		@client_application.application_date = local_params[:application_date]
		 		@client_application.application_origin = local_params[:application_origin]
		 		@client_application.application_received_office = local_params[:application_received_office]

		 	else
		 		can_create_new_application = ClientApplication.can_new_application_be_created?(@client.id)
		 		if can_create_new_application
		 			@client_application = ClientApplication.new(local_params)
		 		else
		 			@client_application.errors[:base] << "This client is associated with a pending application within the same service program group."
		 			render :index
		 			return
		 		end
		 	end
		  	#  5943 - Incomplete
		 	#  5942 - Complete
		 	@client_application.application_status = 5943

		 	if @client_application.save
		 		if session[:new_application_id].blank?

		 			#  Only first Time Application is created Focus client ID is inserted.
		 			# Add the focus client to the Application Member table.
		 			member_object = ApplicationMember.new
		 			member_object.client_id = @client.id
		 			member_object.client_application_id = @client_application.id
		 			member_object.member_status = 4468
		 			member_object.save
		 			flash[:notice] = "Application created."
		 		end
		 		session[:new_application_id] = @client_application.id
		 		# Initialize Session Variable - start - Manoj 10/09/2014
				session[:APPLICATION_ID] = @client_application.id
				# Initialize Session Variable - End - Manoj 10/09/2014
		 		redirect_to new_client_application_path
		 	else
		 		# first step failed - reset sessions
		 		if session[:new_application_id].present?
		 			session[:application_step] = nil
		 		else
		 			session[:new_application_id] = session[:application_step] = nil
		 		end
		 		render :new
		 	end

		elsif @client_application.get_process_object == "client_application_second" && params[:next_button].present?

			# check if application members added?

		 	# if @client_application.application_members.count >= 2
		 	# 	redirect_to new_client_application_path
		 	# else
		 	# 	# go back to previous step and show flash message as error message

		 	# 	@client_application.previous_step
		 	# 	session[:application_step] = @client_application.current_step
		 	# 	@client_application.errors[:base] << "Minimum two members are needed to proceed to next step."
		 	# 	render :new
		 	# end
		 	redirect_to new_client_application_path
		elsif @client_application.get_process_object == "client_application_third" && params[:next_button].present?
			l_params = primary_of_application_params

			if l_params[:self_client_id].present?

				if ApplicationMember.update_primary_applicant_application(session[:new_application_id].to_i,l_params[:self_client_id].to_i) == "SUCCESS"
					@client_application.self_client_id = l_params[:self_client_id].to_i
                    # MANOJ -09/16/2014 - SAVING SELF OF APPLICATION IN THE SESSION[:CLIENT_ID] so that headings are shown properly.
					session[:CLIENT_ID] = @client_application.self_client_id
				else
					flash[:alert] = "Failed to save the primary applicant."
				end
				redirect_to new_client_application_path
			else
				@client_application.previous_step
		 		session[:application_step] = @client_application.current_step
		 		@client_application.errors[:base] << "Primary applicant is required."
		 		render :new
			end


		elsif @client_application.get_process_object == "client_application_fourth" && params[:next_button].present?
			# check if relations are added?
			l_members_count = @client_application.application_members.count
			l_expected_relationship_count = l_members_count * (l_members_count - 1)
			# l_db_relationships = ClientRelationship.get_relationship_maintenance_index_list(@client.id)
			l_db_relationships = ClientRelationship.get_apllication_member_relationships(session[:new_application_id].to_i)
			l_db_relationship_count = l_db_relationships.size

			if l_expected_relationship_count == l_db_relationship_count
				redirect_to new_client_application_path
			else
				# go back to previous step and show flash message as error message
				@client_application.previous_step
		 		session[:application_step] = @client_application.current_step
		 		@client_application.errors[:base] << "Relationships between all the members is required."
		 		render :new
			end

		elsif @client_application.get_process_object == "client_application_fifth" && params[:next_button].present?
			# check if application members added?
		 	@client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(@client_application.id)
		 	if @client_application_question_answers_y_n.present?
		 		redirect_to new_client_application_path
		 	else
		 		# go back to previous step and show flash message as error message
		 		@client_application.previous_step
		 		session[:application_step] = @client_application.current_step
		 		@client_application.errors[:base] << "All questions must be answered to proceed to next step."
		 		render :new
		 	end

		elsif @client_application.current_step == "client_application_last"

			# Last step - there is No NEXT button - hence @client_application.current_step will have correct partial page to process.
			# if params[:commit] =="Complete Application Intake"

				# Only Save button is clicked
				# update the application status as "complete" =5942
				@client_application.application_status = 5942
			# end

			begin
				ActiveRecord::Base.transaction do
					@client_application.save!
					queue_collection = WorkQueue.where("state = 6557 and reference_type = 6587 and reference_id = ?",@client_application.id)
					if queue_collection.present?
						ls_msg = "SUCCESS"
					else
						#  1.Create queue
						#  2.save intake_worker_id
						# step1 : Populate common event management argument structure
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
						common_action_argument_object.event_id = 309 # Save Button
			            common_action_argument_object.queue_reference_type = 6587 # client application
			            common_action_argument_object.queue_reference_id = @client_application.id
			            common_action_argument_object.queue_worker_id = current_user.uid
			            # for task
			            common_action_argument_object.client_application_id = @client_application.id
			            app_member_collection = ApplicationMember.get_primary_applicant(@client_application.id)
			            primary_member_object = app_member_collection.first
			            common_action_argument_object.client_id = primary_member_object.client_id
			            # step2: call common method to process event.
			            ls_msg = EventManagementService.process_event(common_action_argument_object)
					end

		            if ls_msg == "SUCCESS"
		            	#  All steps completed -reset session variables.
						session[:new_application_id] = session[:application_step] = nil
						# redirect to application index page
						flash[:notice] = "Application completed and saved."
						# Manoj 10/29/2014 - Last step will navigate to First step of Application screening.
						# redirect_to client_application_path(@client_application.id)
						 redirect_to application_check_program_eligibility_wizard_initialize_path(@client_application.id)
		            else
		            	# go back to previous step and show flash message as error message
				 		session[:application_step] = @client_application.current_step
				 		@client_application.errors[:base] << "Failed to save the application, #{ls_msg}."
				 		render :new
		            end
				end
			rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationController","complete_application",err,current_user.uid)
					ls_msg = "Failed to complete application - for more details refer to Error ID: #{error_object.id}."
					session[:application_step] = @client_application.current_step
				 	@client_application.errors[:base] << "Failed to save the application, #{ls_msg}."
				 	render :new
			end

		else
			# previous button is clicked.
			redirect_to new_client_application_path
		end
	rescue => err
		# take the user to New action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating application."
		redirect_to_back
	end


	# Edit Link on Application show page will call this action.
	def edit_wizard
		# edit wizard from edit wizard link from index page.

      	#  application ID passed from Index Page

      	session[:application_step] = session[:NAVIGATED_FROM] = nil
      	session[:CALLED_FROM] = "WIZARD"
       	session[:new_application_id] = params[:application_id]

      	# redirect to New action which manages application wizard functionality.
      	redirect_to new_client_application_path
      	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","edit_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing application."
		redirect_to_back

	end


	def new_member_search
		#  Rule : Add Member - has to force user to first search if the member is already in the system. If he is not found then he can add new member.
		#         New member means = new client + same client_id added in application_members against application ID.

		#  New member search is called from WIZARD or Select(NON WIZARD) pages.
		# This action accepts two parameters
		# parameter 1: application_id
		# parameter 2: called from page - WIZARD or NON_WIZARD
		# Routes is setup such that arguments can be passed to conroller actions.
		@show_add_button = false
		@client = Client.new
		# populate parameters into session - since they will be accessed in different actions.
		session[:new_application_id] = params[:application_id]
 		# session[:CALLED_FROM] = params[:called_from]
 		manage_back_button()
 		# open custom search and Add member page - uses partials/search service methods.
 		@client_application = ClientApplication.find(session[:new_application_id].to_i)
		render 'search_and_add_member'

		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","new_member_search",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when searching for member."
		redirect_to_back
	end



	def member_search_results
		#  new_member_search - method will call this action.
		# Call search service to search client.
		@client_application = ClientApplication.find(session[:new_application_id].to_i)
		 l_client_serach_service = SearchModule::ClientSearch.new
		  return_obj = l_client_serach_service.search(params)
	    if return_obj.class.name == "String"

	    	  @show_add_button = true
	    	   # Manoj -09/17/2014
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			   populate_session_from_params(params)
			    # show result or error message.
		    if return_obj == "No results found"
	    		render 'no_data_found_search_results'
	    	else
	    		# flash.now[:notice] = return_obj
	    		@client_application.errors[:base] = return_obj
	    		render 'search_and_add_member'
	    	end
	    else
	    	reset_pre_populate_session_variables()
	      # results found
	      @clients = return_obj
	      @show_add_button = false
	       # show result or error message.
	    	render 'search_and_add_member'
	    end
	      # show result or error message.
	    	# render 'search_and_add_member'
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","member_search_results",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when searching client."
		redirect_to_back
	end

	def set_member_in_session
		# the select button on the search result will call this method.
		# searched client ID is stored in session to be used in Add member page.
	  	session[:MODAL_TARGET_SELECTED_CLIENT_ID] = params[:id]
	  	# session[:NAVIGATED_FROM] = nil
	    # Navigate to new_member creation path.
	    redirect_to new_member_path
	    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","set_member_in_session",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when selecting client."
		redirect_to_back

	end

	# Add member will call this action.
	def new_member
		# action to add new members.
		# This action accepts two parameters
		# parameter 1: application_id
		# parameter 2: called from page - WIZARD or NON_WIZARD
		# Routes is setup such that arguments can be passed to conroller actions.

		@client = Client.find(session[:CLIENT_ID])

		@client_application = ClientApplication.find(session[:new_application_id].to_i)
		@application_member = ApplicationMember.new
		@application_member.client_application_id = @client_application.id
		#  member status Active = 4468
		@application_member.member_status = 4468

		if session[:MODAL_TARGET_SELECTED_CLIENT_ID].present?
			# Member is in the system -add it to application_member table.
			@application_member.client_id = session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i
            # clear the session
            session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
            # save
            if @application_member.save
	  			flash[:notice] = "Member added"
	  		else
	  			flash[:alert] = "Failed to add member to application. #{@application_member.errors.full_messages.last}."
	  		end
	  		# member saved redirect to step 2 or NON wizard edit window.
	  		navigate_to_called_page_session()
	    else
        	#  member is not found in the system- so add client first and then add it to Application_member table.
        	 # open new new_member page so that user will create new client
        	 @client_for_application_member = Client.new
        	if session[:NEW_CLIENT_SSN].present?
        	 	 @client_for_application_member.ssn =  session[:NEW_CLIENT_SSN]
        	end
		   	if session[:NEW_CLIENT_LAST_NAME].present?
	    	 	@client_for_application_member.last_name =  session[:NEW_CLIENT_LAST_NAME]
	    	end
	    	if session[:NEW_CLIENT_FIRST_NAME].present?
	    	 	@client_for_application_member.first_name =  session[:NEW_CLIENT_FIRST_NAME]
	    	end
	    	if session[:NEW_CLIENT_DOB].present?
	    	 	@client_for_application_member.dob =  session[:NEW_CLIENT_DOB]
	    	end
	    	if session[:NEW_CLIENT_GENDER].present?
	    	 	@client_for_application_member.gender =  session[:NEW_CLIENT_GENDER]
	    	end
        	@client = @client_for_application_member
        end

    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","new_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when adding member."
		redirect_to_back


	end






	# Creating Clients from Application Page - when search results are not found.
	def create_new_member
		# Post method of new_member

		# Add to clients table
		# Save the New record to Database - INSERT
		@client_for_application_member = Client.new(client_params)
		 @client = @client_for_application_member
	  	if @client_for_application_member.save
	  		# Add to application_members table
	  		@client_application = ClientApplication.find(session[:new_application_id].to_i)
			@application_member = ApplicationMember.new
			@application_member.client_application_id = @client_application.id
			# add new created client ID
			@application_member.client_id = @client_for_application_member.id
			#  member status = Active
			@application_member.member_status = 4468
			# Save Application member.
			@application_member.save

	  		flash[:notice] = "Member added successfully."
	  		if session[:NEW_CLIENT_SSN].present?
	  			 session[:NEW_CLIENT_SSN] = nil

	  		end
	  		navigate_to_called_page_session()

	  	else
	  		render :new_member
	  	end
	rescue => err
		# take the user to appropriate action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","create_new_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating client."
		redirect_to_back
	end




	# Manage Relationship calls this Action
	def edit_application_member_multiple_relationship
		@client = Client.find(session[:CLIENT_ID])
		# Check at least Two application members are there to proceed.
		selected_application = ClientApplication.find(params[:application_id].to_i)
		application_members = selected_application.application_members
		if application_members.size >= 2 then
			session[:new_application_id] = params[:application_id]
	 		# session[:CALLED_FROM] = params[:called_from]
	 		manage_back_button()
			# @client_multiple_relationships = ClientRelationship.prepare_application_member_relationship_data(params[:application_id].to_i)
			@client_multiple_relationships = ClientRelationship.prepare_application_member_relationship_data_one_direction(params[:application_id].to_i)
		else
			flash[:alert] = "Minimum two application members are needed to setup relationship between them"
			redirect_to client_application_path(params[:application_id].to_i)
		end
	rescue => err
		# take the user to New action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","edit_application_member_multiple_relationship",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when adding relationship."
		redirect_to_back
	end

	# Put action of  Manage Relationship .
	def update_application_member_multiple_relationship
		# @client_multiple_relationships = ClientRelationship.prepare_application_member_relationship_data(session[:new_application_id].to_i)
		@client_multiple_relationships = ClientRelationship.prepare_application_member_relationship_data_one_direction(session[:new_application_id].to_i)
		# logger.debug("-->client_multiple_relationships = #{@client_multiple_relationships.inspect}")
		# fail
		l_params = multiple_relationships_params
		# logger.debug("-->l_params = #{l_params.inspect}")
		# fail
     	if all_relationship_types_populated?(l_params) == true
     		# Manoj Testing 09/22/2014
     		# @client_multiple_relationships = ClientRelationship.update_multiple_relationships(l_params)
     		@client_multiple_relationships = ClientRelationship.update_multiple_relationships_with_inverse_relation(l_params)
			msg = "SUCCESS"
     		@client_multiple_relationships.each do |arg_reln|
				if arg_reln.errors.any?
					msg = "FAIL"
					break
				end
			end
			if msg == "SUCCESS"
				flash[:notice] = "Application member relationships saved successfully."
     			navigate_to_called_page_session()
			else
				render 'edit_application_member_multiple_relationship'
			end

     	else
     		# flash[:alert] = "All Relationship type are not populated"
     		# unique_client_relationships = []
     		@client_relationship_errors = ClientRelationship.new
     		@client_relationship_errors.errors[:base] = "All relationship type are not populated"
			# render :edit_application_member_multiple_relationship
			li = 0
			@client_multiple_relationships.each do |arg_reln|
				# steps.index(current_step)
				l_hash = l_params[li]
				# if li%2 == 0
					arg_reln.relationship_type = l_hash[:relationship_type]
					# unique_client_relationships << arg_reln
				# end
				li = li + 1
			end
			# @client_multiple_relationships = unique_client_relationships
			# logger.debug "UPDATE - second-@client_multiple_relationships -inspect = #{@client_multiple_relationships.inspect}"
			render 'edit_application_member_multiple_relationship'
			# redirect_to edit_application_member_multiple_relationship_path(session[:new_application_id].to_i,"WIZARD")
     	end
     rescue => err
		# take the user to New action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","update_application_member_multiple_relationship",err,current_user.uid)
		# flash[:alert] = "Error ID: #{error_object.id} - Error when Creating Relationship."
		flash[:alert] = "Set up all the relationship between members."
		redirect_to_back
	end

	# Application Members -independent Menu start
		def menu_manage_application_member

			@client = Client.find(session[:CLIENT_ID])
			@client_application = ClientApplication.find(params[:application_id].to_i)
			@application_members = ApplicationMember.sorted_application_members_and_member_info(@client_application.id)
			# manage navigation
			session[:CALLED_FROM] = "NON_WIZARD-APPLICATION_MEMBER"

		rescue => err
			# take the user to New action and write error to table.
			error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","menu_manage_application_member",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
			redirect_to_back
		end


	# Application Members -independent Menu end

	# Application Members relationship -independent Menu start
		def menu_manage_application_member_relationship
			@client = Client.find(session[:CLIENT_ID])
			@client_application = ClientApplication.find(params[:application_id].to_i)
			@client_relations = ClientRelationship.get_apllication_member_relationships(@client_application.id)
			# manage navigation
			session[:CALLED_FROM] = "NON_WIZARD-APPLICATION_MEMBER_RELATIONSHIP"
		rescue => err
			# take the user to New action and write error to table.
			error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","menu_manage_application_member_relationship",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
			redirect_to_back
		end

	# Application Members relationship -independent Menu  end

	# called from Complete Application Link.
	def complete_application


		# check for completeness of application.
		# Rules -
		#  1.Minimum Two members should be there.
		#  2. Relationship should be there
		#  3. Primary Applicant should be selected.
		@client_application = ClientApplication.find(params[:application_id].to_i)
		ls_message = ClientApplication.can_this_application_be_completed(@client_application.id)
		if ls_message == "SUCCESS"
			@client_application.application_status = 5942
			begin
				ActiveRecord::Base.transaction do
					@client_application.save!
					queue_collection = WorkQueue.where("state = 6557 and reference_type = 6587 and reference_id = ?",@client_application.id)
					if queue_collection.present?
					else
						 # create queue & task
						 #  1.Create queue
						#  2.save intake_worker_id
						# step1 : Populate common event management argument structure
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
						common_action_argument_object.event_id = 309 # Save Button
			            common_action_argument_object.queue_reference_type = 6587 # client application
			            common_action_argument_object.queue_reference_id = @client_application.id
			            common_action_argument_object.queue_worker_id = current_user.uid
			            # for task
			            common_action_argument_object.client_application_id = @client_application.id
			            app_member_collection = ApplicationMember.get_primary_applicant(@client_application.id)
			            primary_member_object = app_member_collection.first
			            common_action_argument_object.client_id = primary_member_object.client_id

			            # step2: call common method to process event.
			            ls_msg = EventManagementService.process_event(common_action_argument_object)
			            if ls_msg == "SUCCESS"
			            	flash[:notice] = "Application completed and saved."
			            end
					end
				end
			rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationController","complete_application",err,current_user.uid)
					ls_msg = "Failed to complete application - for more details refer to Error ID: #{error_object.id}."
					flash[:alert] = ls_msg
			end

		else
			@client_application.application_status = 5943
			@client_application.save
			flash[:alert] = ls_message
		end
		redirect_to client_application_path(@client_application.id)
	rescue => err
			# take the user to New action and write error to table.
			error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","complete_application",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when completing application."
			redirect_to_back
	end



	def edit_client_application_question_answers

		@client = Client.find(session[:CLIENT_ID])
		@client_application = ClientApplication.find(params[:application_id].to_i)
		# Insert applications into entity_question_answers if they are not present.
		create_client_application_q_a_records(@client_application.id)
		# reyrieve Question_answers from entity_question_answers
		@client_application_question_answers = EntityQuestionAnswer.get_client_application_q_answers(@client_application.id)
		#  to manage cancel button.
		session[:NAVIGATED_FROM] = new_client_application_path
		 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","edit_client_application_question_answers",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing application."
		redirect_to_back
	end

	# Put action of  Manage Relationship .
	def update_client_application_question_answers


# {"utf8"=>"✓",
#  "_method"=>"put",
#  "authenticity_token"=>"wHECxjboB8LxEj/xBVmX3v9/+C1pjr3lPijht/fypeY=",
#  "client_application_q_answers"=>{"1"=>{"answer_flag"=>"1",
#  "id"=>"1",
#  "question_id"=>"6093"},
#  "2"=>{"answer_flag"=>"1",
#  "id"=>"2",
#  "question_id"=>"6094"},
#  "3"=>{"answer_flag"=>"1",
#  "id"=>"3",
#  "question_id"=>"6095"},
#  "4"=>{"answer_flag"=>"1",
#  "id"=>"4",
#  "question_id"=>"6096"}},
#  "commit"=>"Save",
#  "application_id"=>"29108469"}
		l_params_collection = params[:client_application_q_answers]
		@client_application = ClientApplication.find(params[:application_id].to_i)

		l_params_collection.each do |arg_q_a_hash|
			l_hash = arg_q_a_hash[1] # will have {"answer_flag"=>"1", "id"=>"9", "question_id"=>"6061"}
			q_a_object = EntityQuestionAnswer.find(l_hash[:id])
			q_a_object.question_id = l_hash[:question_id]
			q_a_object.answer_flag = l_hash[:answer_flag]
			q_a_object.save
		end
		redirect_to new_client_application_path

		 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","update_client_application_question_answers",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating application."
		redirect_to_back
	end

	def client_search
		session[:NAVIGATE_FROM] = client_applications_path
		redirect_to client_search_path
		 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientApplicationsController","client_search",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when searching for client."
		redirect_to_back

	end









private





		def params_first_step
			params.require(:client_application).permit(:application_date,:application_origin,:application_received_office)
		end


		def client_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:dob,:gender,:marital_status,:primary_language,:ssn_enumeration_type,:identification_type,:ssn_not_found)
  		end

  		# def member_relation_params
  		# 	params.require(:client_relationship).permit(:to_client_id,:relationship_type,:from_client_id)
  		# end

  		def primary_of_application_params
  			params.require(:client_application).permit(:self_client_id)
  		end

  		# Allowing Arrays through STRONG PARAMETER
#   	[{number:"1234",client_id:"11"},{{number:"1235",client_id:"11"}},{{number:"1444",client_id:"11"}}]
#   	we have to reach the hash inside Array and permit them.
	  	 def multiple_relationships_params
		  params.require(:relationships).map do |p|
		     ActionController::Parameters.new(p.to_hash).permit(:relationship_type,:from_client_id,:to_client_id,:update_flag)
		   end
		end

		# def application_member_primary_params
		# 	params.require(:application_member).permit(:client_id)
  # 		end


  		def all_relationship_types_populated?(arg_params)
			l_return = true
			arg_params.each do |arg_param|
				if arg_param[:relationship_type].blank?
					l_return = false
					break
				end
			end
			return l_return
		end


		def navigate_to_called_page_session()
			#logger.debug "Inside - navigate_to_called_page_session - session[:CALLED_FROM] = #{session[:CALLED_FROM].inspect }"
			#logger.debug "Inside - navigate_to_called_page_session - params[:application_id] = #{params[:application_id].inspect }"

			# Destroy member and relationship can be called from Normal Edit/WIZARD page- This function will navigate back to called page.
			if session[:CALLED_FROM] == "NON_WIZARD-APPLICATION_MEMBER"
				# Manoj 03/23/2015 - FRom Independent Menu navigate to Step. -start
	 			session[:CALLED_FROM]  = nil
	 			session[:application_step] = 'client_application_second'
				session[:new_application_id] =session[:APPLICATION_ID]
	 			# Manoj 03/23/2015 - FRom Independent Menu navigate to Step. -end

	 			# redirect_to menu_manage_application_member_path(session[:APPLICATION_ID])
	 			redirect_to new_client_application_path



			elsif  session[:CALLED_FROM]  == "NON_WIZARD-APPLICATION_MEMBER_RELATIONSHIP"
				# redirect_to menu_manage_application_member_relationship_path(params[:application_id])
				# Manoj 03/23/2015 - FRom Independent Menu navigate to Step. -start
	 			session[:CALLED_FROM]  = nil
	 			session[:application_step] = 'client_application_fourth'
				session[:new_application_id] =session[:APPLICATION_ID]
	 			# Manoj 03/23/2015 - FRom Independent Menu navigate to Step. -end
				# redirect_to menu_manage_application_member_relationship_path(session[:APPLICATION_ID])
				redirect_to new_client_application_path

			else
				session[:CALLED_FROM]  = nil
	 			# session[:new_application_id] = params[:application_id]
	 			session[:new_application_id] = session[:APPLICATION_ID]
	 	 		redirect_to new_client_application_path
	 		end
		end

		def manage_back_button()

	 		if session[:CALLED_FROM] == "NON_WIZARD-APPLICATION_MEMBER"
	 			session[:NAVIGATED_FROM] = menu_manage_application_member_path(session[:APPLICATION_ID])
	 		elsif  session[:CALLED_FROM]  == "NON_WIZARD-APPLICATION_MEMBER_RELATIONSHIP"
	 			session[:NAVIGATED_FROM] = menu_manage_application_member_relationship_path(session[:APPLICATION_ID])

	 		else
	 			session[:NAVIGATED_FROM] = new_client_application_path
	 		end
		end

		def populate_session_from_params(arg_param)
	  	 	if arg_param[:ssn].present?
		    	session[:NEW_CLIENT_SSN] =  arg_param[:ssn]
		    end

		     if arg_param[:last_name].present?
		    	session[:NEW_CLIENT_LAST_NAME] =  arg_param[:last_name]
		    end

		     if arg_param[:first_name].present?
		    	session[:NEW_CLIENT_FIRST_NAME] =  arg_param[:first_name]
		    end

		     if arg_param[:dob].present?
		    	session[:NEW_CLIENT_DOB] =  arg_param[:dob]
		    end

		    if arg_param[:gender].present?
		    	session[:NEW_CLIENT_GENDER] =  arg_param[:gender]
		    end
	  	end

	  	def reset_pre_populate_session_variables()
	  	 	if session[:NEW_CLIENT_SSN].present?
	  			session[:NEW_CLIENT_SSN] = nil
	  		end

	  		if session[:NEW_CLIENT_LAST_NAME].present?
	  			session[:NEW_CLIENT_LAST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_FIRST_NAME].present?
	  			session[:NEW_CLIENT_FIRST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_DOB].present?
	  			session[:NEW_CLIENT_DOB] = nil
	  		end
	  		if session[:NEW_CLIENT_GENDER].present?
	  			session[:NEW_CLIENT_GENDER] = nil
	  		end
	  	end


	  	def create_client_application_q_a_records(arg_client_application_id)
	  	 	# check if any QA present in the household?
	  	 	#  ALl household questions
	  	 	household_pre_screening = ClientApplication.find(arg_client_application_id)
	  	 	all_client_application_questions = CodetableItem.get_client_application_questions()
	  	 	client_application_q_answers = EntityQuestionAnswer.get_client_application_q_answers(arg_client_application_id)
	  	 	if client_application_q_answers.blank?
	  	 		all_client_application_questions.each do |arg_q_a|
	  	 			client_application_q_answer_object = EntityQuestionAnswer.new
	  	 			client_application_q_answer_object.entity_id = arg_client_application_id
	  	 			client_application_q_answer_object.entity_type = 6091  # client application entity
	  	 			client_application_q_answer_object.question_category_id = 146 # client_application question code table id.
					client_application_q_answer_object.question_id = arg_q_a.id
					client_application_q_answer_object.save
	  	 		end
	  	 	end
	  	end

	  	def objects_required_for_show(arg_client_application_id)
	  		# Initialize Session Variable - End - Manoj 10/09/2014
			@client_application = ClientApplication.find(arg_client_application_id)
			# Initialize Session Variable - start - Manoj 10/09/2014
			session[:APPLICATION_ID] = arg_client_application_id.to_i
			if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID])
			else
				primary_applicant_collection = ApplicationMember.get_primary_applicant(@client_application.id)
				if primary_applicant_collection.present?
					primary_applicant_object = 	primary_applicant_collection.first
					session[:CLIENT_ID] = primary_applicant_object.client_id

				else
					application_adults_collection =ApplicationMember.get_adults_in_the_application(@client_application.id)
					if application_adults_collection.present?
						application_adult_object = application_adults_collection.first
						session[:CLIENT_ID] =application_adult_object.client_id
					else
						application_member_collection =ApplicationMember.sorted_application_members(@client_application.id)
						application_member_object = application_member_collection.first
						session[:CLIENT_ID] =application_member_object.client_id
					end
				end

				@client = Client.find(session[:CLIENT_ID])
			end
			set_household_member_info_in_session(session[:CLIENT_ID])
			@application_members = ApplicationMember.sorted_application_members_and_member_info(@client_application.id)
			# Get relationship list for Focus Client.(which will include all relationships between application members)
			@client_relationships = ClientRelationship.get_apllication_member_relationships(arg_client_application_id.to_i)
			@client_application_question_answers_y_n = EntityQuestionAnswer.get_answered_questions(@client_application.id)

	  	end


end