class ClientDocVerficationsController < AttopAncestorController
	# For Application Members -start
	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_applications = ClientApplication.get_completed_applications_list(@client.id)
			@client_applications.each do |arg_app|
				arg_app.application_index_link_path =document_verification_index_path(arg_app.id)

			end
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client"
		redirect_to_back
	end

	def document_verification_index
		#  shows list of documents verified for selected Application ID.
		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_application = ClientApplication.find(params[:application_id])
		@client_doc_verification_list = ClientDocVerfication.get_verified_documents(params[:application_id].to_i)

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","document_verification_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new
		@client_application = ClientApplication.find(params[:application_id])
		@application_members = @client_application.application_members
		@client_doc_verification = ClientDocVerfication.new

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def create
		@client_application = ClientApplication.find(params[:application_id])
		l_params = client_doc_params
		@client_doc_verification = ClientDocVerfication.new(l_params)
		if @client_doc_verification.save
			flash[:notice] = "Verification document added successfully."
			redirect_to document_verification_index_path(@client_application.id)
		else
			render :new
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client"
		redirect_to_back
	end

	def show
		@client_application = ClientApplication.find(params[:application_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client"
		redirect_to_back
	end

	def edit
		@client_application = ClientApplication.find(params[:application_id])
		@application_members = @client_application.application_members
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client"
		redirect_to_back

	end

	def update
		@client_application = ClientApplication.find(params[:application_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		l_params = client_doc_params
		if @client_doc_verification.update(l_params)
			flash[:notice] = "Verification document added successfully"
			redirect_to document_verification_index_path(@client_application.id)
		else
			render :edit
		end

	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def destroy
		@client_application = ClientApplication.find(params[:application_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		@client_doc_verification.destroy
		flash[:alert] = "Document deleted successfully."
		redirect_to document_verification_index_path(@client_application.id)

	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	# For Application Members -end


	#  For Program Unit member Document Management. -start

	def program_unit_document_verification_index

		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_program_units = ProgramUnit.get_client_program_units_list(@client.id)
			logger.debug "@client_program_units - inspect = #{@client_program_units.inspect} "
			@client_program_units.each do |arg_program_unit|
				arg_program_unit.index_link_path = show_program_unit_documents_path(arg_program_unit.id)
				logger.debug "arg_program_unit.index_link_path = #{arg_program_unit.index_link_path.inspect} "
			end
		end

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","program_unit_document_verification_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show_program_unit_documents
		@client = Client.find(session[:CLIENT_ID].to_i)
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@client_doc_verification_list = ClientDocVerfication.get_program_unit_verified_documents(@selected_program_unit.id)

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","show_program_unit_documents",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access document verification."
		redirect_to_back
	end

	def show_one_program_unit_document
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","show_one_program_unit_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access document provided."
		redirect_to_back
	end


	def new_program_unit_member_document
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_unit_members = @selected_program_unit.program_unit_members
		@client_doc_verification = ClientDocVerfication.new

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","new_program_unit_member_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when adding a new document."
		redirect_to_back
	end

	def create_program_unit_member_document

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		l_params = client_doc_params
		@client_doc_verification = ClientDocVerfication.new(l_params)
		if @client_doc_verification.save
			flash[:notice] = "Verification document added successfully."
			redirect_to show_program_unit_documents_path(@selected_program_unit.id)
		else
			render :new_program_unit_member_document
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","create_program_unit_member_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when saving a new document."
		redirect_to_back
	end

	def edit_program_unit_member_document

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_unit_members = @selected_program_unit.program_unit_members
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","edit_program_unit_member_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when editing a new document."
		redirect_to_back
	end

	def update_program_unit_member_document

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		l_params = client_doc_params
		if @client_doc_verification.update(l_params)
			flash[:notice] = "Verification document added successfully."
			redirect_to show_program_unit_documents_path(@selected_program_unit.id)
		else
			render :edit_program_unit_member_document
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","update_program_unit_member_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when updating a new document"
		redirect_to_back
	end

	def destroy_program_unit_document
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		@client_doc_verification.destroy
		flash[:alert] = "Document deleted successfully."
		redirect_to show_program_unit_documents_path(@selected_program_unit.id)

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","destroy_program_unit_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when deleting a new document"
		redirect_to_back
	end

	#  For Program Unit member Document Management. -end


	#  manage - per client basis - start

	def index_focus_client_documents
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_documents = ClientDocVerfication.focus_client_documents(@client.id)
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","index_focus_client_documents",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show_focus_client_document

		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","show_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new_focus_client_document
		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_doc_verification = ClientDocVerfication.new

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","new_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def create_focus_client_document

		@client = Client.find(session[:CLIENT_ID].to_i)
		l_params = client_doc_params
		l_params[:client_id] = @client.id
		@client_doc_verification = ClientDocVerfication.new(l_params)
		if @client_doc_verification.save
			flash[:notice] = "Verification document added successfully."
			redirect_to index_focus_client_documents_path
		else
			render :new_focus_client_document
		end

	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","create_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def edit_focus_client_document

		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_doc_verification = ClientDocVerfication.find(params[:id])

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","edit_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def update_focus_client_document

		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		l_params = client_doc_params
		if @client_doc_verification.update(l_params)
			flash[:notice] = "Verification document added successfully."
			redirect_to index_focus_client_documents_path
		else
			render :edit_focus_client_document
		end

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","update_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def destroy_focus_client_document
		@client_doc_verification = ClientDocVerfication.find(params[:id])
		@client_doc_verification.destroy
		flash[:alert] = "Document deleted successfully."
		redirect_to index_focus_client_documents_path

	   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientDocVerficationsController","destroy_focus_client_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end


	#  manage - per client basis - end




	private

		def client_doc_params
			params.require(:client_doc_verfication).permit(:client_id, :document_type,:document_verfied_date)
  	 	end

end


