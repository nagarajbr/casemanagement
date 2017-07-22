class SystemParamsController <  AttopAncestorController

  def new
 	  @systemparamcategory =  SystemParamCategory.find(params[:system_param_category_id])
   	@systemparams = SystemParam.new
 	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamsController","new",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when creating new system params."
        redirect_to_back
  end

  def create
 	  @systemparamcategory =  SystemParamCategory.find(params[:system_param_category_id])
 	  l_params = arg_params
 	  @systemparams = SystemParam.new(arg_params)
 	  @systemparams.system_param_categories_id = @systemparamcategory.id

 	  if @systemparams.save
 		  redirect_to system_param_category_path(@systemparamcategory), notice: "System params item created."
 	  else
 		  render :new
 	  end
 	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamsController","create",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when creating new system params."
        redirect_to_back
  end

  def edit
  	@systemparamcategory =  SystemParamCategory.find(params[:system_param_category_id])
 	  @systemparams = SystemParam.find(params[:id])
 	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamsController","edit",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when editing system params."
        redirect_to_back
  end

  def update
 	  @systemparamcategory =  SystemParamCategory.find(params[:system_param_category_id])
  	@systemparams = SystemParam.find(params[:id])

 	if @systemparams.update(arg_params)
 		 redirect_to system_param_category_path(@systemparamcategory), notice: "System params item updated."
	else
		render :edit
	end
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("SystemParamsController","update",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when updating system params."
        redirect_to_back
  end

  private

     def arg_params
         params.require(:system_param).permit(:key,:value, :description)
      end

end