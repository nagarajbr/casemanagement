class ClientRelationshipsController < AttopAncestorController
# Author: Manoj Patil
# Date: 09/12/2014
# Description: client_relationships table CRUD operation
# Note : All the Create,Update,Delete operations are done using calling custom methods on Model,because
#        we are dealing with relation & Inverse relation all the time.

	def index
		# List of Relations for FOCUS client.
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			# @client_relationships = ClientRelationship.where("from_client_id= ?",@client.id)
			 # @client_relationships = ClientRelationship.get_relationship_maintenance_index_list(@client.id)
			 # Manoj 10/30/2014 - showing only focus client relationships fix
			 @client_relationships = ClientRelationship.focus_client_relationships(@client.id)

			 # logger.debug "@client_relationships-inspect = #{@client_relationships.inspect}"
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRelationshipsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back

	end


	def new
		# New Relationship between FOCUS client and another client in the System.
		# set up the new client relationship record.
		# From client ID is FOCUS client
		@client = Client.find(session[:CLIENT_ID])
		@client_relationship = ClientRelationship.new
		@client_relationship.from_client_id = @client.id
		# These are used for ClientSearch window.
		#  set up session variables for MODAL client search window.
		# set up the Title
        session[:CALLED_PAGE_TITLE] = "Select related client for: #{@client.get_client_name}."
        # set called Page information.
         #  for BACK button
        session[:NAVIGATED_FROM] = new_client_relationship_path
        #  for navigating to after hitting select button of search result.
        session[:NAVIGATE_TO] = new_client_relationship_path
		if session[:MODAL_TARGET_SELECTED_CLIENT_ID].present?
			# set To client ID
            @client_relationship.to_client_id = session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i
            @target_client=Client.find(session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i)
             session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
        end
        rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRelationshipsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error adding new relationship."
		redirect_to_back
	end

	def create
		# Create relationship record and Inverse relationship if there is one.
		l_param = params_values
		@client = Client.find(session[:CLIENT_ID])
		@client_relationship = ClientRelationship.new(l_param)
		# This involves having to insert two records -hence I am checking valid first - then saving two records in custom transaction.
		if @client_relationship.valid?
			# call Model method to create two records.
			ls_msg = ClientRelationship.create_relationships(l_param[:from_client_id].to_i,l_param[:relationship_type].to_i,l_param[:to_client_id].to_i)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Relationship information saved."
				# reset the sessions
			 	session[:NAVIGATED_FROM] = session[:NAVIGATE_TO] = session[:CALLED_PAGE_TITLE]  = session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
			else
				flash[:notice] = "Failed to save relationship."
			end
			redirect_to client_relationships_path
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRelationshipsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving relationship."
		redirect_to_back
	end

	def destroy
		# delete relationship and inverse relationship record.
		if ClientRelationship.delete_relationship(params[:id]) == "SUCCESS"
			flash[:alert] = " Relationship information deleted."
		else
			flash[:alert] = "Failed to delete relationship."
		end
		redirect_to client_relationships_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRelationshipsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting relationship."
		redirect_to_back
	end




	private

	def params_values
	  	params.require(:client_relationship).permit(:from_client_id,:to_client_id,:relationship_type)
	end

end



