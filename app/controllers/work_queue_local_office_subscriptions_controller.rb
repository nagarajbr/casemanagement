class WorkQueueLocalOfficeSubscriptionsController < AttopAncestorController

	# Manoj Patil
	# 09/2/2015
	# Description: Subscribe Queues to selected Local Office.

	def index
		@all_distinct_work_queue_local_offices_list = WorkQueueLocalOfficeSubscription.get_distinct_local_office_list_for_local_office_queues()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing local office queue subscription list."
		redirect_to_back
	end

	def new
		initialize_objects_for_new_action()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in new operation."
		redirect_to work_queue_local_office_subscriptions_index_path
	end

	def create
		# params for create

		# {"utf8"=>"✓",
		#  "authenticity_token"=>"EKCl4k6pMNl2SPpfw2F5ddjrWEhKV9Mp4ART2/fNmlw=",
		#  "work_queue_local_office_subscription"=>{"local_office_id"=>"18",
		#  "queue_types"=>["",
		#  "6557",
		#  "6559",
		#  "6558",
		#  "6560"]},
		#  "commit"=>"Save"}

		# List similar to new - to manage error render scenario
		initialize_objects_for_new_action()
		# create method normal coding
		l_params = params_values
		# logger.debug("l_params = #{l_params.inspect}")
		@work_queue_local_office_subscription_object = WorkQueueLocalOfficeSubscription.new
		lb_valid_data = true
		if l_params[:local_office_id].blank? && l_params[:queue_types].count == 1
			@work_queue_local_office_subscription_object.errors[:base] << "Local office is mandatory."
			@work_queue_local_office_subscription_object.errors[:base] << "Queue is mandatory."
			# Rails.logger.debug("MANOJ1 = #{@work_queue_local_office_subscription_object.errors[:base].inspect}")
			lb_valid_data = false
		else
			if l_params[:local_office_id].blank?
				@work_queue_local_office_subscription_object.errors[:base] = "Local office is mandatory."
				# Rails.logger.debug("MANOJ2 = #{@work_queue_local_office_subscription_object.errors[:base].inspect}")
				# This is needed to set the value checked by user in new action when we render
				if l_params[:queue_types].count > 1
						l_params[:queue_types].each do |each_queue|
					   		if each_queue.present?
					   			@local_office_queues_in_db_array << each_queue.to_i
					   		end
					   	end
				end
				# Rails.logger.debug("MANOJ4 = #{@local_office_queues_in_db_array.inspect}")
				lb_valid_data = false
			end
			if l_params[:queue_types].count == 1
				if l_params[:local_office_id].present?
					@work_queue_local_office_subscription_object.local_office_id = l_params[:local_office_id]
				end
				@work_queue_local_office_subscription_object.errors[:base] << "Queue is mandatory."
				# Rails.logger.debug("MANOJ3 = #{@work_queue_local_office_subscription_object.errors[:base].inspect}")
				lb_valid_data = false
			end
		end

		if lb_valid_data
			# proceed to save
			queue_list = l_params[:queue_types]
			queue_list.each do |each_queue|
				if each_queue.present?
					new_work_queue_local_office_subscription_object = WorkQueueLocalOfficeSubscription.new
					new_work_queue_local_office_subscription_object.queue_type = each_queue
					new_work_queue_local_office_subscription_object.local_office_id = l_params[:local_office_id] # local office ID
					new_work_queue_local_office_subscription_object.save
				end
			end
			flash[:notice] = "Local office queue subscription information saved."
			redirect_to work_queue_local_office_subscriptions_index_path
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving data."
		redirect_to new_work_queue_local_office_subscription_path
	end

	def edit
		li_local_office_id = params[:local_office_id]
		initialize_objects_for_edit_action(li_local_office_id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in edit operation."
		redirect_to work_queue_local_office_subscriptions_index_path
	end

	def update

		li_local_office_id = params[:local_office_id]
		initialize_objects_for_edit_action(li_local_office_id)
		lb_valid_data = true

		# Input params - when user does not selects queues
  	 # 	{"utf8"=>"✓",
	 # "_method"=>"put",
	 # "authenticity_token"=>"8TYY8MnqwXT5oU3FzHwqdS0SOV4ynrbW6FIOt2JT8mE=",
	 # "commit"=>"Save",
	 # "local_office_id"=>"2"}

 		if params[:work_queue_local_office_subscription].blank?
 			@work_queue_local_office_subscription_object.errors[:base] << "Queue is mandatory."
			lb_valid_data = false
 		else
 			l_params = params_update_values
 		end

		if lb_valid_data
			# Input params - when user selects queues

			# {"utf8"=>"✓",
			#  "_method"=>"put",
			#  "authenticity_token"=>"EKCl4k6pMNl2SPpfw2F5ddjrWEhKV9Mp4ART2/fNmlw=",
			#  "work_queue_local_office_subscription"=>{"queue_types"=>["6557",
			#  "6559",
			#  "6558",
			#  "6560"]},
			#  "commit"=>"Save",
			#  "local_office_id"=>"18"}

			# Rule
			# If queue has child user subscription records - you are not allowed to uncheck it.
			lb_proceed = true
			queue_list = l_params[:queue_types]
			# Rails.logger.debug("queue_list = #{queue_list.inspect}")

			# take care of delete - for deselected items
			local_office_queue_collection_in_db = WorkQueueLocalOfficeSubscription.where("local_office_id = ?",li_local_office_id)
			# store the queue types in array to use array functions later
			local_office_queue_in_db_array = []
			local_office_queue_collection_in_db.each do |each_queue_in_db|
				local_office_queue_in_db_array << each_queue_in_db.queue_type
			end

			local_office_queue_in_db_array.each do |each_queue_in_db|
				if queue_list.include?(each_queue_in_db.to_s) == false
					# if user desects the id present in DB scenario
					# proves it is present in database and it is deselected now
					# Rails.logger.debug("Present in DB not found in checkbox collection")
					# Rails.logger.debug("each_queue_in_db = #{each_queue_in_db.to_s}")

					# check if any user subscriptions are there
					if WorkQueueLocalOfficeSubscription.user_subscriptions_found_for_this_location_queue?(li_local_office_id,each_queue_in_db)
						ls_queue_name = CodetableItem.get_short_description(each_queue_in_db)
						# Rails.logger.debug("Present user subscription = #{ls_queue_name}")
						@work_queue_local_office_subscription_object.errors[:base] << "#{ls_queue_name} is subscribed by user, so you cannot uncheck it."
						lb_proceed = false
						break
					else
						# No user subscriptions are there proceed to delete
						local_office_queue_collection = WorkQueueLocalOfficeSubscription.where("local_office_id = ? and queue_type = ?",li_local_office_id,each_queue_in_db)
						local_office_queue_collection.destroy_all
					end
				end
			end

			if lb_proceed
				# Take care of update
				queue_list.each do |each_queue|
					WorkQueueLocalOfficeSubscription.update_local_office_queue(li_local_office_id,each_queue.to_i)
				end
				flash[:notice] = "Local office queue subscription information saved."
			 	redirect_to work_queue_local_office_subscriptions_index_path
			else
				render :edit
			end
		else
			# lb_valid_data = false
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving data."
		redirect_to edit_work_queue_local_office_subscription_path(li_local_office_id)
	end

	def destroy
		li_local_office_id = params[:local_office_id]
		if WorkQueueLocalOfficeSubscription.user_subscriptions_found_for_local_office_queues?(li_local_office_id)
			ls_office_name = CodetableItem.get_short_description(li_local_office_id)
			flash[:alert] = "Users are subscribed to the queues of this Local Office: #{ls_office_name}, so delete operation is not allowed."
			redirect_to work_queue_local_office_subscriptions_index_path
		else
			local_office_queue_collection = WorkQueueLocalOfficeSubscription.where("local_office_id = ?",li_local_office_id)
			local_office_queue_collection.destroy_all
			flash[:notice] = "Selected Local Office Queues deleted"
			redirect_to work_queue_local_office_subscriptions_index_path
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueueLocalOfficeSubscriptionsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when deleting data."
		redirect_to work_queue_local_office_subscriptions_index_path
	end

	private
		def params_values
	  		params.require(:work_queue_local_office_subscription).permit(:local_office_id, queue_types: [])
	  	end

	  	def params_update_values
	  		params.require(:work_queue_local_office_subscription).permit(queue_types: [])
	  	end

	  	def initialize_objects_for_new_action()
	  		# Show Only LOcal offices which needs Queues
			# Needed local office list = all local office - local office with subscribed queues
	  			db_local_office_array = []
				# All Local office List
				all_local_office_list = CodetableItem.item_list(2,"Local Office List")
				# # local offices in db with queues.
				all_distinct_work_queue_local_offices_list =  WorkQueueLocalOfficeSubscription.get_distinct_local_office_list_for_local_office_queues()
				if all_distinct_work_queue_local_offices_list.present?
					all_distinct_work_queue_local_offices_list.each do |each_local_office|
						db_local_office_array << each_local_office.local_office_id
					end
					local_office_in_db_list = CodetableItem.items_to_include_order_by_id(2,db_local_office_array,"subscribed local office")
					@local_office_list = all_local_office_list - local_office_in_db_list
				else
					@local_office_list = all_local_office_list
				end

				# @all_queues = CodetableItem.active_item_list(196,'Queue List').order("sort_order ASC")
				@all_queues = CodetableItem.where("code_table_id = 196 and active = 't'" ).order("sort_order ASC")

				@work_queue_local_office_subscription_object = WorkQueueLocalOfficeSubscription.new
				@local_office_queues_in_db_array = []
	  	end

	  	def initialize_objects_for_edit_action(arg_subscribed_local_office_id)

			# Queues
			# @all_queues = CodetableItem.active_item_list(196,'Queue List').order("sort_order ASC")
			@all_queues = CodetableItem.where("code_table_id = 196 and active = 't'" ).order("sort_order ASC")
			@local_office_queues_in_db_array = []
			local_office_queues_in_db = WorkQueueLocalOfficeSubscription.get_local_office_queues(arg_subscribed_local_office_id)
			if local_office_queues_in_db.present?
			   	local_office_queues_in_db.each do |each_queue|
			   		@local_office_queues_in_db_array << each_queue.queue_type
			   	end
			end
			@work_queue_local_office_subscription_object = WorkQueueLocalOfficeSubscription.new
			@work_queue_local_office_subscription_object.local_office_id = arg_subscribed_local_office_id
	  	end

end
