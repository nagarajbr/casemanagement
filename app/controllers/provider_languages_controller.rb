class ProviderLanguagesController < AttopAncestorController
	def new
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguage = ProviderLanguage.new
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating provider language"
	     redirect_to_back
	end

	def create
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguage = ProviderLanguage.new(params_values)
		@providerlanguage.provider_id = @provider.id
		if @providerlanguage.save
		 redirect_to provider_languages_path, notice: "Provider language details saved"
		else
		 render :new
		end
	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","create",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating provider language"
	      redirect_to_back
	end

	def show
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguage = ProviderLanguage.find(params[:id])
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Failed to find the provider language"
	      redirect_to_back
	end

	def index
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguages = @provider.provider_languages
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","index",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider"
	      redirect_to_back
	end
	def destroy
		@providerlanguage = ProviderLanguage.find(params[:id])
		@providerlanguage.destroy
		redirect_to provider_languages_path
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","destroy",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error while deleting language"
	      redirect_to_back
	end

	def edit
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguage = ProviderLanguage.find(params[:id])
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","edit",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid language"
	      redirect_to_back
	end

	def update

		@provider = Provider.find(session[:PROVIDER_ID])
		@providerlanguage = ProviderLanguage.find(params[:id])
		if @providerlanguage.update(params_values)
		 redirect_to show_provider_language_path, notice: "Provider language information saved"
		else
		 render :edit
		end
		 rescue => err
	       error_object = CommonUtil.write_to_attop_error_log_table("ProviderLanguagesController","update",err,current_user.uid)
	       flash[:alert] = "Error ID: #{error_object.id} - Error when updating provider language"
	       redirect_to_back
	end

	private

	  def params_values
	  	params.require(:provider_language).permit(:language_type,:start_date,:end_date)
	  end
end