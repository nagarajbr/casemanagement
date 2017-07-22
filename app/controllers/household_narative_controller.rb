class HouseholdNarativeController < AttopAncestorController

	before_action :set_household, only: [:index,:new,:show,:create]
	def index
		@household_narative_collection =NotesService.get_notes_based_on_entity_type_and_entity_id(6742,session[:HOUSEHOLD_ID])
		@household_members = HouseholdMember.sorted_household_members_with_names(session[:HOUSEHOLD_ID])
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("HouseholdNarativeController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid household."
			redirect_to_back
	end

	def new
		@notes = Notes.new
		if params[:notes_type].present?
			@notes.notes_type = params[:notes_type]
		end
		if params[:notes].present?
			@notes.notes = params[:notes]
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("HouseholdNarativeController","new",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new notes for household."
			redirect_to_back
	end

	def create
		@notes = Notes.new
		if params[:notes_type].present? && params[:notes].present?
			if NotesService.save_notes(6742,session[:HOUSEHOLD_ID],params[:notes_type],nil,params[:notes])
				flash[:notice] = "Notes saved."
				redirect_to household_narative_index_path
			else
				flash[:notice] = "Notes cannot be created."
				render :index
			end
		else
			# fail
			if params[:notes_type].blank?
				@notes.errors[:base] << "Notes type is required."
			end
			if params[:notes].blank?
				@notes.errors[:base] << "Notes is required."
			end
			render :new
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("HouseholdNarativeController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new notes for household."
			redirect_to_back
	end

	def show
		@notes_for_type = NotesService.get_notes_for_notes_type(params[:entity_type],params[:entity_id],params[:long_description])
		@long_description = @notes_for_type.first.long_description

		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes_for_type = @notes_for_type.page(params[:page]).per(l_records_per_page) if @notes_for_type.present?
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("HouseholdNarativeController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access household notes failed."
			redirect_to_back
	end

	def show_client_narative
		session[:CLIENT_ID] = params[:client_id]
		redirect_to narative_path
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("HouseholdNarativeController","show_client_narative",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access client notes."
			redirect_to_back
	end

	private

	def set_household
		@household = Household.find(session[:HOUSEHOLD_ID])
	end

end