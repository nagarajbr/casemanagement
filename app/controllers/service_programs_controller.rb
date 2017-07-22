class ServiceProgramsController < AttopAncestorController

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@serviceprogram = ServiceProgram.all.order("description asc").page(params[:page]).per(l_records_per_page)
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","index",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to access service programs."
	    redirect_to_back
	end

	def new
		@serviceprogram = ServiceProgram.new
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to create service programs."
	    redirect_to_back
	end

	def create
			 @serviceprogram = ServiceProgram.new(codeparams)
		  if @serviceprogram.save
			 redirect_to service_programs_path, notice: "Service program created."
		  else
			render :new
		  end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","create",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to create service program."
	    redirect_to_back
	end


	def show
		@serviceprogram = ServiceProgram.find(params[:id])
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to access service program."
	    redirect_to_back
	end

	def edit
		@serviceprogram = ServiceProgram.find(params[:id])
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to edit service program."
	    redirect_to_back
	end


	def update
		@serviceprogram =  ServiceProgram.find(params[:id])
		if @serviceprogram.update(codeparams)
			 redirect_to service_programs_path, notice: "Service program updated."
		  else
			render :edit
		  end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("ServiceProgramsController","update",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to update service program."
	    redirect_to_back
	end


private

	def codeparams
		 params.require(:service_program).permit(:title,:description)
	 end
end



