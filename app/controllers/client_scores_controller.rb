class ClientScoresController < AttopAncestorController
	before_action :get_client, only: [:index,:new,:create,:show,:edit,:update]

	def index
		if assessment_plan_not_required
			@menu = params[:menu]
			@client_scores = ClientScore.get_client_scores(session[:CLIENT_ID])
			@test_types = CodetableItem.active_item_list(59,"Test Type").map(&:id)
			if session[:CLIENT_ASSESSMENT_ID].present?
				@assessment_id = session[:CLIENT_ASSESSMENT_ID].to_i
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@client_assessment.current_step = "/ASSESSMENT/client_scores"
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
		else
			session[:NAVIGATE_FROM] = client_scores_index_path(params[:menu])
			redirect_to assessment_activity_path
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","index",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
	    redirect_to_back
	end

	def new
		@menu = params[:menu]
		@client_score = ClientScore.new
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end

		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client scores."
	      redirect_to_back
	end

	def create
		@menu = params[:menu]
		@client_score = ClientScore.new(param_values)
		@client_score.client_id = session[:CLIENT_ID]
		if @client_score.save
		 redirect_to client_scores_index_path, notice: "Client score saved."
		else
			@client = Client.find(session[:CLIENT_ID])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
		render :new
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","create",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating client score."
	      redirect_to_back
	end

	def show
		@menu = params[:menu]
		@client_score = ClientScore.find(params[:id])
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Failed to find client score."
	      redirect_to_back
	end

	def edit
		@menu = params[:menu]
		@client_score = ClientScore.find(params[:id])
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","edit",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client score."
	      redirect_to_back
	end

	def update
		@menu = params[:menu]
		@client_score = ClientScore.find(params[:id])
		if @client_score.update(param_values)
		 redirect_to client_scores_show_path(@menu,@client_score.id), notice: "Client score saved."
		else
			@client = Client.find(session[:CLIENT_ID])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
		 render :edit
		end
		rescue => err
	       error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","update",err,current_user.uid)
	       flash[:alert] = "Error ID: #{error_object.id} - Error when updating client score"
	       redirect_to_back
	end

	def destroy
		@menu = params[:menu]
		@client_score = ClientScore.find(params[:id])
		@client_score.destroy
		redirect_to client_scores_index_path, alert: "Client score information deleted."
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ClientScoresController","destroy",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error while deleting client score."
	      redirect_to_back
	end

	private

	def param_values
		params.require(:client_score).permit(:test_type,:date_referred,:date_test_taken_on,:scores)
	end

	def get_client
		@client = Client.find(session[:CLIENT_ID])
	end
end