class WorkQueueUserSubscriptionsController < AttopAncestorController

	# Manoj Patil
	# 09/3/2015
	# Description: Subscribe Queues to selected User.

	def index
		# show list of username|local office|subscribed queues
		session[:USERQUEUE_SUBSCRIPTION_STEP] = session[:USERQUEUE_USER_ID] = session[:USERQUEUE_USER_LOCATION] = nil
		@all_distinct_work_queue_users_list = WorkQueueUserSubscription.get_distinct_user_and_local_office_list_for_user_queues()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing user queue subscription list."
		redirect_to_back
	end

	# MANOJ 09/03/2015 - User Queue subscription wizard
	def user_queue_subscription_wizard_initialize
  		session[:USERQUEUE_SUBSCRIPTION_STEP] = session[:USERQUEUE_USER_ID] = session[:USERQUEUE_USER_LOCATION] = nil
  		redirect_to start_user_queue_subscription_wizard_path
  	end


	def start_user_queue_subscription_wizard

		if session[:USERQUEUE_SUBSCRIPTION_STEP].blank?
	  	 	session[:USERQUEUE_SUBSCRIPTION_STEP] = nil
	  	end

		if session[:USERQUEUE_USER_ID].present?
			# user_id is saved in the session
			initialize_first_step_instance_variables()
			@work_queue_user_subscription_object = WorkQueueUserSubscription.new
			@work_queue_user_subscription_object.user_id = session[:USERQUEUE_USER_ID]
			# second  step Instance variables
			initialize_second_step_instance_variables()
		else
			# first step
			@work_queue_user_subscription_object = WorkQueueUserSubscription.new
			initialize_first_step_instance_variables()
		end

		if session[:USERQUEUE_USER_LOCATION].present?
			@work_queue_user_subscription_object = WorkQueueUserSubscription.new
			@work_queue_user_subscription_object.user_id = session[:USERQUEUE_USER_ID]
			@work_queue_user_subscription_object.local_office_id = session[:USERQUEUE_USER_LOCATION].to_i
			initialize_last_step_instance_variables()
		end

		@work_queue_user_subscription_object.current_step = session[:USERQUEUE_SUBSCRIPTION_STEP]

	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","start_user_queue_subscription_wizard",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured when adding user queues."
			redirect_to_back

    end

    def process_user_queue_subscription_wizard


    	# like create REST action
		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.

		# populate instance variables
		if session[:USERQUEUE_USER_ID].blank?
      	 	@work_queue_user_subscription_object = WorkQueueUserSubscription.new
      	else
      	 	@work_queue_user_subscription_object = WorkQueueUserSubscription.new
      	 	@work_queue_user_subscription_object.user_id = session[:USERQUEUE_USER_ID]
      	end
      	@work_queue_user_subscription_object.current_step = session[:USERQUEUE_SUBSCRIPTION_STEP]

      	 # manage steps
      	if params[:back_button].present?
      		 @work_queue_user_subscription_object.previous_step
      	elsif @work_queue_user_subscription_object.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
          @work_queue_user_subscription_object.next_step
        end
       session[:USERQUEUE_SUBSCRIPTION_STEP] = @work_queue_user_subscription_object.current_step
       #manage steps - end


        # what step to process?
		if @work_queue_user_subscription_object.get_process_object == "user_queue_subscription_first" && params[:next_button].present?

			l_params = params_first_step
			if l_params[:user_id].present?

				session[:USERQUEUE_USER_ID]  =  l_params[:user_id]
				redirect_to start_user_queue_subscription_wizard_path
			else

				initialize_first_step_instance_variables()
				@work_queue_user_subscription_object.errors[:base] << "User is mandatory."
				@work_queue_user_subscription_object.previous_step
		 		session[:USERQUEUE_SUBSCRIPTION_STEP] = @work_queue_user_subscription_object.current_step
				render :start_user_queue_subscription_wizard
			end
		elsif @work_queue_user_subscription_object.get_process_object == "user_queue_subscription_second" && params[:next_button].present?

			l_params = params_second_step
			if l_params[:local_office_id].present?
				session[:USERQUEUE_USER_LOCATION]  =  l_params[:local_office_id]
				redirect_to start_user_queue_subscription_wizard_path
			else
				initialize_second_step_instance_variables()
				@work_queue_user_subscription_object.errors[:base] << "Local Office is mandatory."
				@work_queue_user_subscription_object.previous_step
		 		session[:USERQUEUE_SUBSCRIPTION_STEP] = @work_queue_user_subscription_object.current_step
				render :start_user_queue_subscription_wizard
			end
		elsif @work_queue_user_subscription_object.current_step == "user_queue_subscription_last" && params[:finish].present?
				# 	{"utf8"=>"✓",
					 # "authenticity_token"=>"9EmTMwCQtDqsg3n1p8S8QsdTU0CTR6cknVJbhLC6gEI=",
					 # "finish"=>"Finish"}
			lb_valid = true
			if params[:work_queue_user_subscription].blank?
				lb_valid = false
				initialize_last_step_instance_variables()
				@work_queue_user_subscription_object.errors[:base] << "Queue is mandatory."
		 		session[:USERQUEUE_SUBSCRIPTION_STEP] = @work_queue_user_subscription_object.current_step
		 		render :start_user_queue_subscription_wizard
			end

			# {"utf8"=>"✓",
			#  "authenticity_token"=>"zm9tjHs+QHTH5gulqYZ++QErKuBXCd8y8CWNaBUOe6M=",
			#  "work_queue_subscription"=>{"queue_types"=>["",
			#  "6557",
			#  "6558"]},
			#  "commit"=>"Finish"}

			if lb_valid == true
				l_params = params_last_step
				if l_params[:queue_types].count == 1
					# No queues selected
						# {"utf8"=>"✓",
						#  "authenticity_token"=>"zm9tjHs+QHTH5gulqYZ++QErKuBXCd8y8CWNaBUOe6M=",
						#  "work_queue_subscription"=>{"queue_types"=>[""]},
						#  "commit"=>"Finish"}
					initialize_last_step_instance_variables()
					@work_queue_user_subscription_object.errors[:base] << "Queue is mandatory."
			 		session[:USERQUEUE_SUBSCRIPTION_STEP] = @work_queue_user_subscription_object.current_step
			 		# Rails.logger.debug("befor render = #{@work_queue_user_subscription_object.current_step.inspect}")
			 		render :start_user_queue_subscription_wizard
				else
					# user has entered queues - proceed to save
					queue_list = l_params[:queue_types]
					queue_list.each do |each_queue|
						if each_queue.present?
							new_work_queue_local_office_subscription_object = WorkQueueUserSubscription.new
							new_work_queue_local_office_subscription_object.queue_type = each_queue
							new_work_queue_local_office_subscription_object.user_id = session[:USERQUEUE_USER_ID]
							new_work_queue_local_office_subscription_object.local_office_id = session[:USERQUEUE_USER_LOCATION].to_i
							new_work_queue_local_office_subscription_object.save
						end
					end
					flash[:notice] = "User queue subscription information saved."
					session[:USERQUEUE_SUBSCRIPTION_STEP] = session[:USERQUEUE_USER_ID] = session[:USERQUEUE_USER_LOCATION] = nil
					redirect_to work_queue_user_subscriptions_index_path
				end
			end
		else
			# back button
			redirect_to start_user_queue_subscription_wizard_path
		end

	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","process_user_queue_subscription_wizard",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured when creating queues."
			redirect_to_back
  end



  def edit
		li_user_id = params[:user_id]
		li_office_id = params[:local_office_id]
		initialize_objects_for_edit_action(li_user_id,li_office_id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in edit operation."
		redirect_to work_queue_user_subscriptions_index_path
	end

	def update
		# {"utf8"=>"✓",
		#  "_method"=>"put",
		#  "authenticity_token"=>"gGsuXw4E9WqxiLXOP/tqOsTMYQ1pBKHxsTmekRGnotM=",
		#  "work_queue_subscription"=>{"queue_types"=>["6557",
		#  "6559"]},
		#  "commit"=>"Save",
		#  "user_id"=>"14"}


		li_user_id = params[:user_id]
		li_office_id = params[:local_office_id]
		initialize_objects_for_edit_action(li_user_id,li_office_id)
		lb_valid_data = true
		 #  	{"utf8"=>"✓",
		 # "_method"=>"put",
		 # "authenticity_token"=>"gGsuXw4E9WqxiLXOP/tqOsTMYQ1pBKHxsTmekRGnotM=",
		 # "commit"=>"Save",
		 # "user_id"=>"14"}
 		if params[:work_queue_user_subscription].blank?
 			@work_queue_user_subscription_object.errors[:base] << "Queue is mandatory."
			lb_valid_data = false
 		else
 			l_params = params_update_values
 		end
		if lb_valid_data
			# logger.debug("l_params = #{l_params.inspect}")
			# proceed to save
			user_queue_collection = WorkQueueUserSubscription.list_of_queues_for_user(li_user_id,li_office_id)
			if user_queue_collection.present?
				user_queue_collection.destroy_all
				saving_user_subscribed_queues(l_params[:queue_types],li_user_id,li_office_id)
			elsif l_params[:queue_types].present?
				saving_user_subscribed_queues(l_params[:queue_types],li_user_id,li_office_id)
			else
				flash[:alert] = "Failed to save user's queue subscription information."
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving data."
		redirect_to_back
	end





	def destroy
		li_user_id = params[:user_id]
		li_local_office_id =  params[:local_office_id]
		user_queue_collection = WorkQueueUserSubscription.list_of_queues_for_user(li_user_id,li_local_office_id)
		user_queue_collection.destroy_all
		flash[:notice] = "Selected User Queue(s) deleted"
		redirect_to work_queue_user_subscriptions_index_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueUserSubscriptionsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when deleting data."
		redirect_to_back
	end





	private

		def saving_user_subscribed_queues(arg_queue_type_collection,arg_user_id,arg_office_id)
			queue_list = arg_queue_type_collection
			queue_list.each do |each_queue|
				new_work_queue_local_office_subscription_object = WorkQueueUserSubscription.new
				new_work_queue_local_office_subscription_object.queue_type = each_queue
				new_work_queue_local_office_subscription_object.user_id = arg_user_id
				new_work_queue_local_office_subscription_object.local_office_id = arg_office_id
				new_work_queue_local_office_subscription_object.save
			end
			flash[:notice] = "User's queue subscription information saved."
			redirect_to work_queue_user_subscriptions_index_path
		end

		def params_first_step
			params.require(:work_queue_user_subscription).permit(:user_id)
		end

		def params_second_step
			params.require(:work_queue_user_subscription).permit(:local_office_id)
		end

		def params_last_step
	  		params.require(:work_queue_user_subscription).permit(queue_types: [])
	  	end

	  	def params_update_values
	  		params.require(:work_queue_user_subscription).permit(queue_types: [])
	  	end

	  	def initialize_last_step_instance_variables()

			# Last step Instance variables
			# User Locations
			li_user_id = session[:USERQUEUE_USER_ID]
			user_object = User.where("uid = ?",li_user_id).first
			@user_name = "#{user_object.name}"
			@users_local_office_name = CodetableItem.get_short_description(session[:USERQUEUE_USER_LOCATION].to_i)
			# Rails.logger.debug("@user_name = #{@user_name}")
			# Rails.logger.debug("@users_local_office_name = #{@users_local_office_name}")

			# User Location Queues
			local_office_queues = WorkQueueLocalOfficeSubscription.get_local_office_queues(session[:USERQUEUE_USER_LOCATION].to_i)

			# Rails.logger.debug("local_office_queues = #{local_office_queues.inspect}")

			if local_office_queues.present?
				li_queue_list_array = []
				local_office_queues.each do |each_queue|
					li_queue_list_array << each_queue.queue_type
				end
				@user_location_queues = CodetableItem.items_to_include_order_by_id(196,li_queue_list_array,"subscribed local office queues")
			else
				@user_location_queues = ""
			end
			@user_queues_in_db_array = []

	  	end

	  	def initialize_first_step_instance_variables()
			all_users = User.all
			@users_list = all_users
			# Rails.logger.debug("all_users = #{all_users.inspect}")
			# distinct users with queues
			# users_with_queue_in_db = User.users_with_queues()

			# Rails.logger.debug("users_with_queue_in_db = #{users_with_queue_in_db.inspect}")
			# @users_list = all_users - users_with_queue_in_db



			# Rails.logger.debug("@users_list = #{@users_list.inspect}")
	  	end



	  	def initialize_second_step_instance_variables()
			# User Locations
			li_user_id = session[:USERQUEUE_USER_ID]
			user_object = User.where("uid = ?",li_user_id).first
			@user_name = "#{user_object.name}"
			# users_local_offices = User.get_user_local_offices(li_user_id)
			users_local_offices = UserLocalOffice.get_local_offices_for_given_user(li_user_id)
			if users_local_offices.present?
					li_users_local_office_list_array = []
					users_local_offices.each do |each_location|
						li_users_local_office_list_array << each_location.local_office_id
					end
					codetable_user_local_office_list = CodetableItem.items_to_include_order_by_id(2,li_users_local_office_list_array,"users local office list")
					user_queues_with_local_office = WorkQueueUserSubscription.get_distinct_local_offices_for_user_queues(li_user_id)
					if user_queues_with_local_office.present?
						li_users_queue_local_office_list_array = []
						user_queues_with_local_office.each do |each_local_office|
							li_users_queue_local_office_list_array << each_local_office.local_office_id
						end
						codetable_queue_local_office_list = CodetableItem.items_to_include_order_by_id(2,li_users_queue_local_office_list_array,"users local office list")
						@user_local_office_list = codetable_user_local_office_list - codetable_queue_local_office_list
					else
						@user_local_office_list = codetable_user_local_office_list
					end
			else
				@user_local_office_list = nil
			end
			return @user_local_office_list

	  	end



	  	def initialize_objects_for_edit_action(arg_user_id,arg_local_office_id)
	  		# user instance variables
	  		user_object = User.where("uid = ?",arg_user_id).first
			@user_name = "#{user_object.name}"
			@users_local_office_name = CodetableItem.get_short_description(arg_local_office_id)
			# Queues
			local_office_queues = WorkQueueLocalOfficeSubscription.get_local_office_queues(arg_local_office_id)
			li_queue_list_array = []
			local_office_queues.each do |each_queue|
				li_queue_list_array << each_queue.queue_type
			end
			@all_queues = CodetableItem.items_to_include_order_by_id(196,li_queue_list_array,"subscribed local office queues")
			# This list should be array of numbers.
			@user_queues_in_db_array = []
			user_queues_in_db = WorkQueueUserSubscription.get_subscribed_user_queues_for_local_office(arg_user_id,arg_local_office_id)
			user_queues_in_db.each do |each_queue|
				@user_queues_in_db_array << each_queue.queue_type
			end

			@work_queue_user_subscription_object = WorkQueueUserSubscription.new
			@work_queue_user_subscription_object.user_id = arg_user_id
			@work_queue_user_subscription_object.local_office_id = arg_local_office_id
	  	end



end
