class UserLocalOfficesController < AttopAncestorController
	def index
		@all_user_local_office_list = UserLocalOffice.get_all_user_locations
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("UserLocalOfficesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing all users local office list."
		redirect_to_back
	end

	def new_initialize
		session["USER_ID_SAVE_ADD"] = nil
		redirect_to user_local_offices_new_path
	end


	def new
		initialize_instance_variables()
		@user_local_office_object = UserLocalOffice.new
		if session["USER_ID_SAVE_ADD"].present?
			@user_local_office_object.user_id =session["USER_ID_SAVE_ADD"]
			@user_local_office_list_save_and_add = UserLocalOffice.where("user_id = ?",session["USER_ID_SAVE_ADD"])
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("UserLocalOfficesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in new operation."
		redirect_to user_local_offices_index_path
	end

	def create
		l_params = params_values
		@user_local_office_object = UserLocalOffice.new
		if session["USER_ID_SAVE_ADD"].blank?
			@user_local_office_object.user_id = l_params[:user_id]
		else
			@user_local_office_object.user_id = session["USER_ID_SAVE_ADD"]
		end
		@user_local_office_object.local_office_id = l_params[:local_office_id]
		if params[:save_and_add].present?

			# {"utf8"=>"✓",
		 # "authenticity_token"=>"Ep1ZdPKddfVdhQTp6Tc26zToy8Ix9oKPODdpxqoZ1k4=",
		 # "user_local_office"=>{"user_id"=>"34",
		 # "local_office_id"=>"18"},
		 # "save_and_add"=>"Save & Add"}

			if @user_local_office_object.save
				session["USER_ID_SAVE_ADD"] = @user_local_office_object.user_id
				redirect_to user_local_offices_new_path
			else
				initialize_instance_variables()
				render :new
			end
		end
		if params[:save_and_exit].present?
			# {"utf8"=>"✓",
		 # "authenticity_token"=>"Ep1ZdPKddfVdhQTp6Tc26zToy8Ix9oKPODdpxqoZ1k4=",
		 # "user_local_office"=>{"user_id"=>"34",
		 # "local_office_id"=>"18"},
		 # "save_and_exit"=>"Save & Exit"}
			if @user_local_office_object.save
				session["USER_ID_SAVE_ADD"] = nil
				redirect_to user_local_offices_index_path
			else
				initialize_instance_variables()
				render :new
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("UserLocalOfficesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving data."
		redirect_to user_local_offices_new_path
	end

	def destroy
		user_local_office_object = UserLocalOffice.find(params[:id].to_i)
		user_local_office_object.destroy
		flash[:notice] = "Selected user local office record is deleted."
		if session["USER_ID_SAVE_ADD"].present?
			redirect_to user_local_offices_new_path
		else
			redirect_to user_local_offices_index_path

		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("UserLocalOfficesController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when deleting data."
		redirect_to user_local_offices_index_path
	end

	private
		def params_values
	  		params.require(:user_local_office).permit(:user_id,:local_office_id)
	  	end

	  	def initialize_instance_variables()

	  		if session["USER_ID_SAVE_ADD"].present?
	  			# Show Only LOcal offices which ARE NOT ASSIGNED TO USER
			    # Needed local office list = all local office - local office with USER
	  			db_local_office_array = []
				# All Local office List
				all_local_office_list = CodetableItem.item_list(2,"Local Office List")
				# # local offices in db with queues.
				all_user_local_offices_list = UserLocalOffice.where("user_id = ?",session["USER_ID_SAVE_ADD"])
				if all_user_local_offices_list.present?
					all_user_local_offices_list.each do |each_local_office|
						db_local_office_array << each_local_office.local_office_id
					end
					local_office_in_db_list = CodetableItem.items_to_include_order_by_id(2,db_local_office_array,"user local office")
					@local_office_list = all_local_office_list - local_office_in_db_list
				else
					@local_office_list = all_local_office_list
				end

	  		else
	  			@users_list = User.all
	  			@local_office_list = CodetableItem.item_list(2,'Local Office List')
	  		end


	  	end
end
