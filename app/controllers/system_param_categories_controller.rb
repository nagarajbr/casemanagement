class SystemParamCategoriesController < AttopAncestorController
	before_action :set_system_params_category_id, only: [:edit, :update ]

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@systemparamcategory = SystemParamCategory.all.page(params[:page]).per(l_records_per_page)
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","index",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when accessing profile."
        redirect_to_back
	end

	def new
		@systemparamcategory = SystemParamCategory.new
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","new",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when trying to create system params category."
        redirect_to_back
	end

	def create
	@systemparamcategory = SystemParamCategory.new(arg_params)

		if @systemparamcategory.save
			redirect_to system_param_categories_path, notice: "System param category created."
		else
			render :new
		end
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","create",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when trying to create system params category."
        redirect_to_back
	end

	def edit

	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","edit",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when trying to edit system params category."
        redirect_to_back
	end

	def update

		  if @systemparamcategory.update(arg_params)
			 redirect_to system_param_categories_path, notice: "System param category updated."
		  else
			render :edit
		  end

	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","update",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when trying to update system params category"
        redirect_to_back
	 end

	def show

		@systemparamcategory =  SystemParamCategory.find(params[:id])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@system_params = SystemParamCategory.get_system_param_records_for_category(@systemparamcategory.id).page(params[:page]).per(l_records_per_page)

		 # @system_params=  @systemparamcategory.system_params

	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamCategoriesController","show",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when trying to view system params category."
        redirect_to_back

	end

	private

		def arg_params
			 params.require(:system_param_category).permit(:description)
		 end

		 def set_system_params_category_id
			 @systemparamcategory =  SystemParamCategory.find(params[:id])
		 end
end
