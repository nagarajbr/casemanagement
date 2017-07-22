class CodeTablesController < AttopAncestorController
	before_action :set_code_table_id, only: [:edit, :update ]

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@codetable = CodeTable.all.order("name asc").page(params[:page]).per(l_records_per_page)
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","index",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when accessing codetable values."
       redirect_to_back
	end

	def new
		@codetable = CodeTable.new
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","new",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when creating new codetable values."
       redirect_to_back
	end

	def create
		 @codetable = CodeTable.new(codeparams)
		  if @codetable.save
			 redirect_to code_tables_path, notice: "Code table created."
		  else
			render :new
		  end
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","create",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Error when creating new codetable values."
       redirect_to_back

	end

	def edit
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","edit",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Failed to edit codetable values."
       redirect_to_back
	end

	def update
		  if @codetable.update(codeparams)
			 redirect_to code_tables_path, notice: "Code table updated."
		  else
			render :edit
		  end
	rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","update",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Failed to update codetable values."
       redirect_to_back
	end

	def show
		@codetable =  CodeTable.find(params[:id])
		l_records_per_page = SystemParam.get_pagination_records_per_page
       @codetableitems =  @codetable.codetable_items.order("short_description  asc").page(params[:page]).per(l_records_per_page)
    rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("CodeTablesController","show",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Failed to display codetable values."
       redirect_to_back
	end

    private

	def codeparams
		 params.require(:code_table).permit(:name, :description)
	 end

	 def set_code_table_id
		 @codetable =  CodeTable.find(params[:id])
	 end
end
