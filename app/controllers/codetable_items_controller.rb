class CodetableItemsController < AttopAncestorController
 before_action :set_code_table_item_id, only: [:edit, :update]

  def new
   	@codetable =  CodeTable.find(params[:code_table_id])
    @codetableitem = @codetable.codetable_items.new
  rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("CodetableItemsController","new",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Failed to create new codetable item values."
     redirect_to_back
  end

  def create
     @codetable =  CodeTable.find(params[:code_table_id])
  	 @codetableitem = @codetable.codetable_items.new(codeitemparams)
     #  for school type -STI = fields Type and Parent_id should be populated.
     if @codetableitem.save
         # if  @codetableitem.code_table_id == 21
         # if  @codetableitem.code_table_id == 21 || @codetableitem.code_table_id == 9
           update_object = CodetableItem.find(@codetableitem.id)
           case @codetableitem.code_table_id
            when 21
              update_object.type = "SchoolType"
              update_object.parent_id = @codetableitem.id
            when 9
               update_object.type = "Race"
            when 114
              update_object.type = "DisabilityCharacteristic"
            when 115
              update_object.type = "HealthCharacteristic"
            when 112
              update_object.type = "OtherCharacteristic"
           end # end of case statement
            update_object.save
        # end # end of if codetable-iem == 21
         redirect_to code_table_path(@codetable), notice: "Code table item created."
      else
        render :new
      end
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("CodetableItemsController","create",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Failed to create new codetable item values."
    redirect_to_back
  end

  def edit
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("CodetableItemsController","edit",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Failed to edit a codetable item value."
    redirect_to_back
  end

  def update
    if @codetableitem.update(codeitemparams)
       redirect_to code_table_path(@codetable), notice: "Code table item updated."
    else
      render :edit
    end
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("CodetableItemsController","update",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Failed to update a codetable item values."
    redirect_to_back
  end

  private

    def set_code_table_item_id
       @codetable =  CodeTable.find(params[:code_table_id])
       @codetableitem =  CodetableItem.find(params[:id])
    end

    def codeitemparams
      table_name = @codetableitem.present? ? @codetableitem.class.name.underscore.to_sym : :codetable_item
      params.require(table_name).permit(:short_description, :long_description, :system_defined, :active)
    end
end