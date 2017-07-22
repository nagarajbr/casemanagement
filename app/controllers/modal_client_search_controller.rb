 class ModalClientSearchController < AttopAncestorController
 	# Author : Manojkumar PAtil
	# Date : 08/27/2014
	# Description : Modal Client Search - to be used to Select Target client -(Not Focus Client ro be used in Client NoteBook)
	#  Sets the target client id in session[:MODAL_TARGET_SELECTED_CLIENT_ID] - This session  ID will be used in either Controller- NEW/EDIT action to set the cliend ID in the field.
	 # Sets session[:NAVIGATED_FROM] with requested URL before coming to this page - so that after selecting Client it needs to
	#  Go back to previously requested page.
	# Example refer to :-ClientParentalRspabilitiesController.rb


  def new
  	# Open new Coomon TARGET client search window - (Not FOCUS Client)
  	@client = Client.new
  	# Store from where the request came from - so that when searched client is selected - we have to redirect him back to request page.
  	# session[:NAVIGATED_FROM] ||= request.referer
  	# logger.debug "MNP-session[:NAVIGATED_FROM] in model controller= #{session[:NAVIGATED_FROM] }"
  	# navigate to common TARGET client page.
  	render 'shared/modal_search_client'
  end



  def search
	        # Manoj 09/01/2014
	    # Client search from SEarch service object
	    #  09/01/2014
	    l_client_serach_service = SearchModule::ClientSearch.new
	    # Client search service will return Client result object or Error Message string object
	    return_obj = l_client_serach_service.search(params)
	    if return_obj.class.name == "String"
	      # flash the error message
	      flash.now[:notice] = return_obj
	    else
	      # results found
	      @clients = return_obj
	    end

	  	render 'shared/modal_search_client'
  end



   def set_client_in_modal_session
  	session[:MODAL_TARGET_SELECTED_CLIENT_ID] = params[:id]
  	# redirect_to session.delete(:NAVIGATED_FROM)
  	# logger.debug "MNP-params[:id]= #{params[:id] }"
  	# logger.debug "MNP-MODAL_TARGET_SELECTED_CLIENT_ID= #{session[:MODAL_TARGET_SELECTED_CLIENT_ID] }"
  	# redirect_to session[:NAVIGATED_FROM]
  	 session[:NAVIGATED_FROM] = nil
  	 redirect_to session.delete(:NAVIGATE_TO)
  	 # logger.debug "MNP-session[:NAVIGATED_FROM]= #{session[:NAVIGATED_FROM] }"
  end



end


