class EmploymentDetailsController < AttopAncestorController
	# Author : Manoj Patil
	# Date: 08/12/2014
	# Description : CRUD for employment_details tabel

  def index

      @menu = params[:menu]
    	@client= Client.find(session[:CLIENT_ID])
    	l_param = params[:employment_id]
    	@employment = Employment.find(l_param)
      @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
		  @employment_details =  @employment.employment_details
      if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
        @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
        @assessment_object = @client_assessment
      end

      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
           set_hoh_data(@client.id)
      end

  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","index",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employment detail."
    redirect_to_back

	end

	def new

     @menu = params[:menu]
		 @client= Client.find(session[:CLIENT_ID])
		 l_param = params[:employment_id]
		 @employment =  Employment.find(l_param)
     @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
	   @employment_detail = @employment.employment_details.new
      if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
        @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
        @assessment_object = @client_assessment
      end
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)

      end
      populate_position_types_dropdown
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","new",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new employment detail."
    redirect_to_back
	end

	def create
    # fail
    @menu = params[:menu]
    l_param = params[:employment_id]
    @client= Client.find(session[:CLIENT_ID])
    @employment =  Employment.find(l_param)
    @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
    if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
      set_hoh_data(@client.id)
    end
    employment_details_object = EmploymentDetail.employment_details_records_given_employment_id(@employment.id)
    l_emp_detail_params = params_values
    @employment_detail = @employment.employment_details.new(l_emp_detail_params)
    if @employment_detail.position_type.present?
      combined_position_type = @employment_detail.position_type
      @employment_detail.position_type = combined_position_type.split("$").last
      @employment_detail.position_type_desc = combined_position_type.split("$").first
    end
    if @employment_detail.valid?
      # fail
      employment_collection = EmploymentDetail.employment_details_record(@employment_detail.employment_id,@employment_detail.position_type.to_s )
        if employment_collection.blank?
          if employment_details_object.present?
            if employment_details_object.first.salary_pay_frequency == params_values[:salary_pay_frequency].to_i
               create_employment_details
            else
                 @employment_detail.errors[:base] << "All employment details should have same salary frequency"
                  populate_position_types_dropdown
                  render :new
            end
          else
            create_employment_details
          end
        else
           @employment_detail.errors[:base] << "Employemnt details position type #{@employment_detail.position_type_desc} already taken."
            populate_position_types_dropdown
            render :new
        end
    else
      # fail
      populate_position_types_dropdown
      render :new
    end
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","create",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new Employment detail"
    redirect_to_back
	end

	def show
      @menu = params[:menu]
  		@client= Client.find(session[:CLIENT_ID])
    	l_employment_id = params[:employment_id]
    	@employment = Employment.find(l_employment_id)
      @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
    	l_employment_detail_id = params[:employment_detail_id]
    	@employment_detail = EmploymentDetail.find(l_employment_detail_id)
      if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
          @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
          @assessment_object = @client_assessment
      end
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
       set_hoh_data(@client.id)
     end
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","show",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to view employment detail."
    redirect_to_back
   	end

   	def edit
      @menu = params[:menu]
   		@client= Client.find(session[:CLIENT_ID])
    	l_employment_id = params[:employment_id]
    	@employment = Employment.find(l_employment_id)
      @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
    	l_employment_detail_id = params[:employment_detail_id]
    	@employment_detail = EmploymentDetail.find(l_employment_detail_id)
      # @employment_detail.position_type = "#{@employment_detail.position_type_desc}$#{@employment_detail.position_type}"
      if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
          @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
          @assessment_object = @client_assessment
      end
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)
      end
      # onet = OnetWebService.new("arwins","9436zfu")
      # @position_types = onet.get_occupations
      populate_position_types_dropdown
  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","edit",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit employment detail."
    redirect_to_back
   	end

   	def update

      @menu = params[:menu]
   		@client= Client.find(session[:CLIENT_ID])
    	l_employment_id = params[:employment_id]
    	@employment = Employment.find(l_employment_id)
      @employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
    	l_employment_detail_id = params[:employment_detail_id]
    	@employment_detail = EmploymentDetail.find(l_employment_detail_id)
      employment_details_object = EmploymentDetail.employment_details_records_given_employment_id(l_employment_id)
        l_param_values = params_values
        @employment_detail.assign_attributes(l_param_values)
        Rails.logger.debug("@employment_detail after update1 = #{@employment_detail.inspect}")
        if @employment_detail.position_type.present?
          combined_position_type = @employment_detail.position_type
          @employment_detail.position_type = combined_position_type.split("$").last
          @employment_detail.position_type_desc = combined_position_type.split("$").first
        end
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
       set_hoh_data(@client.id)
      end
      if @employment_detail.valid?
         employment_collection = EmploymentDetail.employment_details_record(@employment_detail.employment_id,@employment_detail.position_type.to_s )
          if (employment_collection.blank? || employment_collection.count == 1)
             if employment_details_object.count>1
                if (employment_details_object.first.salary_pay_frequency == params_values[:salary_pay_frequency].to_i)
                   update_employment_details
                else
                     @employment_detail.errors[:base] << "All employment details should have same salary frequency"
                      populate_position_types_dropdown
                      render :edit
                end
              else
                 update_employment_details
              end
          else
             @employment_detail.errors[:base] << "Employemnt details position type #{@employment_detail.position_type_desc} already taken."
              populate_position_types_dropdown
              render :edit
          end

      else
        populate_position_types_dropdown
        render :edit
      end

    rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","update",err,current_user.uid)
      flash[:alert] = "Failed to save employment details - for more details refer to Error ID: #{error_object.id}."
      redirect_to_back
   	end

   	def destroy
      @menu = params[:menu]
   		@client= Client.find(session[:CLIENT_ID])
    	l_employment_id = params[:employment_id]
    	@employment = Employment.find(l_employment_id)
    	l_employment_detail_id = params[:employment_detail_id]
    	@employment_detail = EmploymentDetail.find(l_employment_detail_id)
      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        set_hoh_data(@client.id)
      end
      income_collection = Income.where("employment_id = ?",@employment.id)
      if income_collection.present?
         flash[:alert] = "Employement information cannot deleted, because dependent income information found."
      else
  	  	@employment_detail.destroy
        flash[:alert] = "Employment information deleted."
      end
	    if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
        redirect_to  household_member_employment_detail_index_path(@client.id,@employment.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
      else
        redirect_to  employment_employment_details_path(@menu,@employment.id)
      end

  rescue => err
    error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetailsController","destroy",err,current_user.uid)
    flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete employment detail."
    redirect_to_back

  end

  private

    def params_values
           params.require(:employment_detail).permit(:effective_begin_date, :effective_end_date,
                                                     :hours_per_period, :salary_pay_amt,
                                                     :salary_pay_frequency,:position_type,
                                                     :current_status)
    end

      # Manoj 11/20/2015
    # def set_employment_detail_hoh_data(arg_client_id)
    #   set_hoh_data(arg_client_id)
    #   @income = Income.find(params[:income_id].to_i)

    # end

    def populate_position_types_dropdown
      onet = OnetWebService.new("arwins","9436zfu")
      @position_types = onet.get_occupations
      if @employment_detail.position_type.present?
        @employment_detail.position_type = "#{@employment_detail.position_type_desc}$#{@employment_detail.position_type}"
      end
    end

    def create_employment_details
         ls_msg = EmploymentDetailService.save_employment_detail(@employment_detail,session[:CLIENT_ID])
            if ls_msg == "SUCCESS"
              # fail
              flash[:notice] = "Employment detail saved."
                if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                redirect_to household_member_employment_detail_index_path(@client.id,@employment.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                else
                  if session[:NAVIGATE_FROM].blank?
                  redirect_to employment_employment_detail_path(@menu,@employment.id, @employment_detail.id)
                  else
                  navigate_back_to_called_page()
                  end
                end
            else
              # fail
                if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
                @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
                @assessment_object = @client_assessment
                end
              populate_position_types_dropdown
              flash[:alert] = ls_msg
              render :new
            end

    end

    def update_employment_details

        ls_msg = EmploymentDetailService.update_employment_detail(@employment_detail,session[:CLIENT_ID])
        logger.debug("ls_msg = #{ls_msg}")
        if ls_msg == "SUCCESS"
          flash[:notice] = "Employment detail saved."
          if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
              redirect_to show_household_member_employment_detail_path(@client.id,@employment.id, @employment_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
          else
             if session[:NAVIGATE_FROM].blank?
              redirect_to employment_employment_detail_path(@menu,@employment.id, @employment_detail.id)
            else
              navigate_back_to_called_page()
            end
          end

        else
          if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
            @client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
            @assessment_object = @client_assessment
          end
          populate_position_types_dropdown
          render :edit
        end
    end

end
