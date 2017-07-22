class ExpenseDetailsController < AttopAncestorController
    before_action :set_id, only: [:index, :new, :create, :show, :edit, :update, :destroy ]

    before_action :filter_use_code, only: [:new, :edit, :create, :update]

  def index
     @client= Client.find(session[:CLIENT_ID])
    # Manoj 11/24/2015 - called from Household member step
    @menu = nil
    if params[:menu].present?
      @menu = params[:menu]
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)
      end
    end


    @expensedetails =  @expense.expense_details
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","index",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid expense record."
    redirect_to_back
	end

	def new
     @client= Client.find(session[:CLIENT_ID])
    @menu = nil
    if params[:menu].present?
      @menu = params[:menu]
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)
      end
    end


	   @expensedetail = @expense.expense_details.new
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","new",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid expense record."
    redirect_to_back
  end

	  def create
       @client= Client.find(session[:CLIENT_ID])
         @menu = nil
        if params[:menu].present?
          @menu = params[:menu]
          if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
           set_hoh_data(@client.id)
          end
        end

	      @expensedetail = @expense.expense_details.new(params_values)
          if @expensedetail.valid?
            ls_msg = ExpenseDetailService.create_client_expense_detail_and_notes(@expensedetail,session[:CLIENT_ID],params[:notes])
            if ls_msg == "SUCCESS"
                flash[:notice] = "Expense created."
                if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                  redirect_to household_member_expense_detail_index_path(@client.id,@expense.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                else
                  redirect_to expense_expense_details_path(@expense.id)
                end
            else

              flash[:notice] = ls_msg
              render :new
            end
          else
            render :new
          end

	  rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","create",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Error when saving expense detail record."
      redirect_to_back
    end

	  def show
      @client= Client.find(session[:CLIENT_ID])
      @menu = nil
      if params[:menu].present?
        @menu = params[:menu]
        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
          set_hoh_data(@client.id)
          @expensedetail =  ExpenseDetail.find(params[:expense_detail_id])
        end
      else
        @expensedetail =  ExpenseDetail.find(params[:id])
      end

      @notes = NotesService.get_notes(6150,session[:CLIENT_ID],6504,@expensedetail.id)
      l_records_per_page = SystemParam.get_pagination_records_per_page
      @notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
      rescue => err
        error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","show",err,current_user.uid)
        flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid expense detail record."
        redirect_to_back
   	end

   	def edit
       @client= Client.find(session[:CLIENT_ID])
      @menu = nil
      if params[:menu].present?
        @menu = params[:menu]
        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
          set_hoh_data(@client.id)
          @expensedetail =  ExpenseDetail.find(params[:expense_detail_id])
        end
      else
        @expensedetail =  ExpenseDetail.find(params[:id])
      end


       @notes =nil # NotesService.get_notes(6150,session[:CLIENT_ID],6504,@expensedetail.id)
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","edit",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Error when edit expense detail record."
    redirect_to_back
    end

  def update
      @client= Client.find(session[:CLIENT_ID])
     @menu = nil
      if params[:menu].present?
        @menu = params[:menu]
        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
         set_hoh_data(@client.id)
          @expensedetail =  ExpenseDetail.find(params[:expense_detail_id])
        end
      else
        @expensedetail =  ExpenseDetail.find(params[:id])
      end



        @expensedetail.expense_due_date = params_values[:expense_due_date]
        @expensedetail.expense_amount = params_values[:expense_amount]
        @expensedetail.expense_use_code = params_values[:expense_use_code]
        @expensedetail.payment_method = params_values[:payment_method]
        @expensedetail.payment_status = params_values[:payment_status]
        @expensedetail.expense_calc_ind = params_values[:expense_calc_ind]
        if @expensedetail.valid?
          ls_msg = ExpenseDetailService.update_client_expense_detail_and_notes(@expensedetail,session[:CLIENT_ID],params[:notes])
          if ls_msg == "SUCCESS"
            flash[:notice] = "Expence detail saved."
            if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                redirect_to household_member_expense_detail_index_path(@client.id,@expense.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
            else
                redirect_to expense_expense_details_path(@expense.id)
            end
          else
            flash[:notice] = ls_msg
            render :edit
          end
        else
          render :edit
        end

  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","update",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Error when updating expense detail record."
    redirect_to_back
  end


  def destroy
         @client= Client.find(session[:CLIENT_ID])
    @menu = nil
    if params[:menu].present?
      @menu = params[:menu]
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)
        @expensedetail =  ExpenseDetail.find(params[:expense_detail_id])
      end
    else
      @expensedetail =  ExpenseDetail.find(params[:id])
    end



    @notes = NotesService.get_notes(6150,session[:CLIENT_ID],6504,@expensedetail.id)
    ls_msg = ExpenseDetailService.delete_client_expense_detail_and_notes(@expensedetail,session[:CLIENT_ID],@notes)
    if ls_msg == "SUCCESS"
      flash[:notice] = "Expense detail deleted."
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        redirect_to household_member_expense_detail_index_path(@client.id,@expense.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
      else
        redirect_to expense_expense_details_path(@expense.id)
      end
    else
      flash[:notice] = ls_msg
      render :show
    end
 rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetailsController","index",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Error when delete expense detail record."
    redirect_to_back


  end

   private

	   def set_id
    	 @expense =  Expense.find(params[:expense_id])
     end



     def filter_use_code
        if @expense.expensetype == 2640 then
           @code_table_list = CodetableItem.items_to_include(77,[4377,4378,4369],"Expense use")
        else
           @code_table_list = CodetableItem.items_to_exclude(77,[4377,4378],"Expense use")
        end
     end

     def params_values
         params.require(:expense_detail).permit(:expense_due_date, :expense_amount, :expense_use_code,
         	                                     :payment_method, :payment_status, :expense_calc_ind)
     end

     # Manoj 11/24/2015
    # def set_hoh_data()
    #   li_member_id = params[:household_member_id].to_i
    #   @household_member = HouseholdMember.find(li_member_id)
    #   @household = Household.find(@household_member.household_id)
    #   @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
    # end

end
