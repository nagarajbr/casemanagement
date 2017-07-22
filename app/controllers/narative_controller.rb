class NarativeController < AttopAncestorController
	before_action :set_client_id
	before_action :set_notes, only: [:edit,:update]

	def index
		@current_uri = request.env['HTTP_REFERER'].include? "household_narative"
		@narative_notes_types = NotesService.get_notes_related_to_client(session[:CLIENT_ID])
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
			redirect_to_back
	end

	def create
		if NotesService.save_notes(6150,session[:CLIENT_ID],params[:notestype],nil,params[:notes])
			flash[:notice] = "Notes saved."
			redirect_to narative_path
		else
			flash[:notice] = "Notes cannot be created."
			render :index
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when saving notes."
			redirect_to_back
	end

	def show
		@notes_for_type = NotesService.get_notes_for_notes_type(params[:entity_type],params[:entity_id],params[:long_description])
		@long_description = @notes_for_type.first.long_description
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes_for_type = @notes_for_type.page(params[:page]).per(l_records_per_page)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access notes."
			redirect_to_back
	end

	def edit
		@long_description = CodetableItem.get_long_description(@notes.notes_type)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit notes."
			redirect_to_back
	end

	def update
		@notes.notes = params[:notes]
		@long_description = CodetableItem.get_long_description(@notes.notes_type)
		if params[:notes].present?
			if @notes.save
				flash[:notice] = "Notes saved."
				redirect_to narative_show_path(@notes.entity_type,@notes.entity_id,@long_description)
			else
				flash[:notice] = "Notes cannot be updated."
				render :index
			end
		else
			entity_type = @notes.entity_type
			entity_id = @notes.entity_id
			long_description = @long_description
			@notes.destroy
			redirect_to narative_path
		end

		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when updating notes."
			redirect_to_back
	end

	private

	def set_client_id
	  	@client = Client.find(session[:CLIENT_ID])
	  	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NarativeController","set_client_id",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Failed to find a client."
			redirect_to client_search_path
    end

    def set_notes
    	@notes = Notes.find(params[:id])
    end
end