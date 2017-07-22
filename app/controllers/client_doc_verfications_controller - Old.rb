class ClientDocVerficationsController < AttopAncestorController
	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_applications = ClientApplication.get_completed_applications_list(@client.id)
		end
	end

	def document_verification_index
		#  shows list of documents verified for selected Application ID.
		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_application = ClientApplication.find(params[:application_id])
		@client_doc_verification_list = ClientDocVerfication.get_verified_documents(params[:application_id].to_i)

	end

	def new

		@client_doc_verification = ClientDocVerfication.new
		@client_application = ClientApplication.find(params[:application_id])
	end

	def create

		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_application = ClientApplication.find(params[:application_id])

		l_params = ClientDocVerfication.doc_verification_params(params)
		if l_params.present?
			logger.debug "l_params-inspect= #{l_params.inspect}"
			return_obj = ClientDocVerfication.create_multiple_records(l_params,@client.id)
		    if return_obj.class.name == "String"
		      # flash the error message
		      flash[:alert] = "Failed to Save document type verification"
			  # render :new
			  redirect_to new_client_doc_verfication_path(@client_application.id)
		    else
		      flash[:notice] = "Selected Verification Document types Saved Successfully"
		      redirect_to document_verification_index(@client_application.id)
		    end
		else
			flash[:alert] = "No Document type selected"
			redirect_to new_client_doc_verfication_path(@client_application.id)
		end
	end

	def edit

		@client_application = ClientApplication.find(params[:application_id])
		# just a place holder to save
		@client_doc_verification = ClientDocVerfication.new
	end

	def update
		fail
		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_application = ClientApplication.find(params[:application_id])

		l_params = ClientDocVerfication.doc_verification_params(params)
		if l_params.present?
			logger.debug "l_params-inspect= #{l_params.inspect}"
			return_obj = ClientDocVerfication.update_multiple_records(l_params,@client.id)
		    if return_obj.class.name == "String"
		      # flash the error message
		      flash[:alert] = "Failed to Save document type verification"
			  # render :new
			  redirect_to new_client_doc_verfication_path(@client_application.id)
		    else
		      flash[:notice] = "Selected Verification Document types Saved Successfully"
		      redirect_to document_verification_index(@client_application.id)
		    end
		else
			flash[:alert] = "No Document type selected"
			redirect_to new_client_doc_verfication_path(@client_application.id)
		end
	end
end
