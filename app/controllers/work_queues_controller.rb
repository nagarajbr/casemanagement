class WorkQueuesController < AttopAncestorController

	def my_queue_summary
		# who is the logged in user
		 @logged_in_user = current_user.uid
		# get distinct list of queues which he has subscription
		 # @subscribed_queues_of_logged_in_user = WorkQueueUserSubscription.get_distinct_queues_subscribed_by_user(@logged_in_user)
		 @subscribed_queues_of_logged_in_user = WorkQueueUserSubscription.get_distinct_queues_with_local_offices_subscribed_by_user(@logged_in_user)
	rescue => err
		Rails.logger.debug("inside exception")
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueuesController","my_queue_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing records from my queue."
		redirect_to_back
	end

	def selected_queue_details_edit
		# fail
		set_instance_variables()
		@work_queue_object = WorkQueue.new
		user_object = User.where("uid = ?",current_user.uid).first
		@role_id = user_object.get_role_id()
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("WorkQueuesController","selected_queue_details_edit",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing details of selected queue."
	 	redirect_to my_queues_summary_path

	end

	def selected_queue_details_update

		# {"utf8"=>"✓",
		#  "_method"=>"put",
		#  "authenticity_token"=>"DXZC0hStbQE6DOHynlweRIQouKG/4vcvbTGv9HT/m+M=",
		#  "work_queue_ids"=>["1",
		#  "2"],
		#  "worker_id"=>"221",
		#  "commit"=>"Assign/Reassign Worker",
		#  "queue_type"=>"6557",
		#  "logged_in_user_id"=>"34"}
		set_instance_variables()
		li_selected_queue_records_array = []
		if all_mandatory_fields_are_selected
			params[:work_queue_ids].each do |each_queue|
				li_selected_queue_records_array << each_queue.to_i
			end
			# assign select records from queue to selected user.
			ls_msg = WorkQueue.assign_multiple_queue_records_to_user(params[:worker_id].to_i,li_selected_queue_records_array, params[:eligibility_worker_id].to_i)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Assignment successful."
			else
				flash[:alert] = ls_msg
			end
			redirect_to selected_queue_details_edit_path(@selected_queue_type,@selected_local_office_id)
		else
			render :selected_queue_details_edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkQueuesController","selected_queue_details_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when assigning user."
		redirect_to selected_queue_details_edit_path(@selected_queue_type,@selected_local_office_id)
	end

	def assign_record_from_queue_to_me
		set_instance_variables()
		li_queue_id = params[:id].to_i
		ls_msg = WorkQueue.assign_record_from_queue_to_me(@logged_in_user,li_queue_id)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Assignment successful."
		else
			flash[:notice] = ls_msg
		end
		redirect_to selected_queue_details_edit_path(@selected_queue_type,@selected_local_office_id)
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("WorkQueuesController","assign_record_from_queue_to_me",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occured when assigning record from queue to me."
	 	redirect_to selected_queue_details_edit_path(@selected_queue_type,@selected_local_office_id)
	end


	private
		def set_instance_variables()
			@work_queue_ids = []
			@selected_queue_type = params[:queue_type].to_i
			@selected_local_office_id = params[:local_office_id].to_i
			@selected_queue_name = CodetableItem.get_short_description(@selected_queue_type)
			@logged_in_user = current_user.uid
			# @subscribed_queue_records = WorkQueue.get_queue_records_for_given_queue_type_and_user_id(@selected_queue_type,@logged_in_user)
            l_records_per_page = SystemParam.get_pagination_records_per_page
            work_queue_records = WorkQueue.get_queue_records_for_given_queue_type_and_local_office_and_user_id(@selected_queue_type,@selected_local_office_id,@logged_in_user)
			@subscribed_queue_records = work_queue_records.page(params[:page]).per(l_records_per_page) if work_queue_records.present?
			@user_list = nil
			# if @role_id == 5 || @role_id == 6
				# @user_list = WorkQueueUserSubscription.get_all_users_in_the_local_office_of_the_supervisor(@logged_in_user, @selected_queue_type)
				@user_list = WorkQueueUserSubscription.get_all_users_subscribed_to_given_queue_and_local_office(@selected_queue_type,@selected_local_office_id)
			# end
			# @user_list = User.all
			@worker_id = nil
			case @selected_queue_type
			when 6557,6735 # 6557 - "Ready for Application Processing", 6735 -"Applications Queue"
				@partial = 'application_queue_partial'
			when 6558 # "Ready for Eligibility Determination"
				@partial = 'determine_eligibility_queue'
			when 6559 # "Ready for Work Readiness Assessment"
				@partial = 'assessment_queue_partial'
				@caption = "Check one or more assessments to assign/reassign"
			when 6560 # "Ready for Employment Readiness planning"
				@partial = 'assessment_queue_partial'
				@caption = "Check one or more employment planning to assign/reassign"
			when 6561 #
				@partial = 'cpp_queue_partial'
			when 6625 #
				@partial = 'approved_cpp_for_client'
			when 6626 #
				@partial = 'approved_cpp_for_program_unit'
			when 6562 # "Ready for Program Unit Activation"

				@partial = 'request_for_first_time_beneit_amount_approval'
				@caption = "Check one or more benefit amount approvals to assign/reassign"
			when 6616 #"Active Program Units"
				# Open Program Unit Queue
				@partial = 'open_program_units_queue'
				@caption = "Check one or more program units to assign/reassign"
			when 6631 #
				# Assessment Completed Queue
				@partial = 'assessment_completed_queue'
			when 6637 #
				# "Ready for Career Pathway Planning Approval"
				@partial = 'ready_for_cpp_approval_for_program_unit'

				@caption = "Check one or more career plan approvals to assign/reassign"
			when 6642 #
				@partial = 'sanction_partial'
			when 6615 #
				@partial = 'reevaluation_queue'
			when 6717 #
				@partial = 'pre_screening_queue'
			when 6654 #
				@partial = 'provider_payment_queue'
			end
		end

		def all_mandatory_fields_are_selected
			result = true
			queue_type = params[:queue_type].to_i
			worker_id_present = queue_type == 6616 ? (params[:worker_id].present? || params[:eligibility_worker_id].present?) : params[:worker_id].present?
			# Rails.logger.debug("params[:work_queue_ids].present? = #{params[:work_queue_ids].present?}")
			# Rails.logger.debug("worker_id_present = #{worker_id_present}")
			# fail
			unless params[:work_queue_ids].present? && worker_id_present
				result = false
				@work_queue_object = WorkQueue.new
				user_object = User.where("uid = ?",current_user.uid).first
				@role_id = user_object.get_role_id()
				@work_queue_object.errors[:base] << "No queue record selected." if params[:work_queue_ids].blank?
				if queue_type == 6616
					if params[:eligibility_worker_id].blank? && params[:worker_id].blank?
						@work_queue_object.errors[:base] << "Please select either case manager or eligibility worker."
					end
				else
					params[:worker_id].blank? ? @work_queue_object.errors[:base] << "User is mandatory." : @worker_id = params[:worker_id].to_i
				end
				@eligibility_worker_id = params[:eligibility_worker_id] if params[:eligibility_worker_id].present?
				@worker_id = params[:worker_id] if params[:worker_id].present?
				@work_queue_ids = params[:work_queue_ids].to_a.map(&:to_i)
			end
			return result
		end
end
