class NoticeGenerationBatch < FillablePdfForm

    def initialize(arg_object)
        @pdf_data = arg_object
        # Rails.logger.debug("-->NoticeGenerationBatch initialize = #{@pdf_data.inspect}")
        super()
    end

protected

    def fill_out

    # first = @pdf_data.firstname
    # Rails.logger.debug("--> @pdf_data[:PRIMARY_CLIENT_FULL_NAME] = #{@pdf_data[:PRIMARY_CLIENT_FULL_NAME].inspect}")
    # if @pdf_data[:PRIMARY_CLIENT_FULL_NAME].middle_name.present?
        # fill  :Clientfirstandlastname,@pdf_data[:PRIMARY_CLIENT_FULL_NAME].first_name.upcase+' '+@pdf_data[:PRIMARY_CLIENT_FULL_NAME].middle_name.first.upcase+' '+@pdf_data[:PRIMARY_CLIENT_FULL_NAME].last_name.upcase
    # else
        fill  :Clientfirstandlastname,@pdf_data[:PRIMARY_CLIENT_FULL_NAME].upcase
    # end

    #client Address
    @pdf_data[:NOTICE].name
    # Rails.logger.debug("testust @pdf_data[:CLIENT_MAILING_ADDRESS] = #{@pdf_data[:CLIENT_MAILING_ADDRESS].inspect}")
    pdf_client_mailing_address = @pdf_data[:CLIENT_MAILING_ADDRESS]
    # Rails.logger.debug("pdf_client_mailing_address = #{pdf_client_mailing_address.class}")
    fill :ClientAddressLine1, @pdf_data[:CLIENT_MAILING_ADDRESS].address_line1.upcase
         if @pdf_data[:CLIENT_MAILING_ADDRESS].address_line2.present?
            fill :ClientAddressLine2,  @pdf_data[:CLIENT_MAILING_ADDRESS].address_line2.upcase
            fill :ClientAddressLine3,@pdf_data[:CLIENT_MAILING_ADDRESS].city.upcase+ '  ' +CodetableItem.get_short_description(@pdf_data[:CLIENT_MAILING_ADDRESS].state).upcase+ '  ' +@pdf_data[:CLIENT_MAILING_ADDRESS].zip.to_s
        else
            fill :ClientAddressLine2, @pdf_data[:CLIENT_MAILING_ADDRESS].city.upcase + '  ' +CodetableItem.get_short_description(@pdf_data[:CLIENT_MAILING_ADDRESS].state).upcase+ '  ' +@pdf_data[:CLIENT_MAILING_ADDRESS].zip.to_s
        end


    # # county Adderss
    if @pdf_data[:NOTICE].processing_location.present?
          fill  :Addressline1, CodetableItem.get_short_description(@pdf_data[:NOTICE].processing_location).upcase
          fill :AddressLine2, @pdf_data[:LOCAL_OFFICE_INFO].street_address1.upcase
          if @pdf_data[:LOCAL_OFFICE_INFO].mailing_address1.present?
                fill :AddressLine3,  @pdf_data[:LOCAL_OFFICE_INFO].mailing_address1.upcase
                fill :AddressLine4, CodetableItem.get_short_description(@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_city).upcase + '  ' +CodetableItem.get_short_description(@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_state).upcase+ '  ' +@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_zip + '-' +@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_zip_suffix
          else
                fill :AddressLine3, CodetableItem.get_short_description(@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_city).upcase + '  ' +CodetableItem.get_short_description(@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_state).upcase+ '  ' +@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_zip + '-' +@pdf_data[:LOCAL_OFFICE_INFO].mailing_address_zip_suffix
          end
          if @pdf_data[:LOCAL_OFFICE_INFO].phone_number.present?
              phone = @pdf_data[:LOCAL_OFFICE_INFO].phone_number.to_s
              phone = phone[0,3]+'-'+phone[3,3]+'-'+phone[6,4]
              fill :phone, phone
          end
    end

    # #caseworker
    fill :Notice,@pdf_data[:NOTICE].notice_generated_date.strftime("%m/%d/%Y")
    # @pdf_data.actiondate = Date.today
    #should be changed "6367"-  "Work on Sanction Task- Days to complete = 15"
    l_days_to_complete_task = SystemParam.get_key_value(18,"6367","Number of days to complete Task - Approve PGU- Days to complete = 7")
    l_days_to_complete_task = l_days_to_complete_task.to_i
    ldt_due_date = Date.today + l_days_to_complete_task
    # @pdf_data.date
    fill :Action, @pdf_data[:NOTICE].date_to_print.strftime("%m/%d/%Y")
    fill :Appeal, "#{ldt_due_date.strftime("%m/%d/%Y")}"

    fill :casenumber,@pdf_data[:NOTICE].reference_id
    case_manager = User.where("uid = ?",@pdf_data[:NOTICE].case_manager_id.to_s)
    fill :CASEWORKER, case_manager.first.name.upcase

    if @pdf_data[:NOTICE_TEXT].present?  and (@pdf_data[:NOTICE].action_type == 6100 or @pdf_data[:NOTICE].action_type == 6099 or @pdf_data[:NOTICE].action_type == 6043 or @pdf_data[:NOTICE].action_type == 6719)
        fill :Noticetext ,@pdf_data[:NOTICE_TEXT].notice_text.gsub(/([\*])/, "\n")

        if @pdf_data[:NOTICE_TEXT].flag2 == true
            # client who is turning 19
            fill  :Household, "           HOUSEHOLD    MEMBERS    AFFECTED    BY    THIS    ACTION             "
            # if @pdf_data.age == 19
            # Rails.logger.debug("@pdf_data[:PROGRAM_BENFIT_MEMBERS] = #{@pdf_data[:PROGRAM_BENFIT_MEMBERS].inspect}")
            program_benfit_members = ''
            @pdf_data[:PROGRAM_BENFIT_MEMBERS].each do |program_members|

              client_name = Client.get_client_full_name_from_client_id(program_members.client_id)
              # Rails.logger.debug("client_name = #{client_name.inspect}")
              program_benfit_members += client_name.ljust(110)
              # Rails.logger.debug("program_benfit_members = #{program_benfit_members.inspect}")
              fill  :membername, "Name"  + '  '.ljust(110) + "Name"
              #        fill  :memberdetails, first_name + ' ' +@pdf_data.last + '                             ' +"TURNED AGE 19"
              fill  :memberdetails, program_benfit_members
            end

        end
        # Rails.logger.debug("@pdf_data[:PROGRAM_BENEFIT_DETAILS] = #{@pdf_data[:PROGRAM_BENEFIT_DETAILS].inspect}")
        if @pdf_data[:NOTICE_TEXT].flag1 == true
            fill  :eligibility, "***  YOUR   ELIGIBILITY   WAS   DETERMINED   AS    SHOWN   BELOW ***"
            fill  :eligibilityline1, "GROSS EARNED "
            fill  :eligibilityline2, "WORK DEDUCTION   "
            fill  :eligibilityline3, "INCENTIVE DEDUCTION "
            fill  :eligibilityline4, "NET INCOME  "
            fill  :eligibilityline5, "TOTAL UNEARNED  "
            fill  :eligibilityline6, "TOTAL ADJUSTED INCOME "
            fill  :eligibilityline7, "FULL BENEFIT "
            fill  :eligibilityline8, "REDUCTION  "
            fill  :eligibilityline9, "SANCTION "
            fill  :eligibilityline10,"BENIFIT AMOUNT "
            fill  :dollar,"$"
            amount1 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_gross_earned
            amount2 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_work_deduct
            amount3 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_incent_deduct
            amount4 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_net_income
            amount5 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_tot_unearned
            amount6 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_tot_adjusted
            amount7 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].full_benefit
            amount8 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].reduction
            amount9 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].sanction
            amount10 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].program_benefit_amount

            fill  :amount1,amount1+ '  '+ " * "
            fill  :amount2,amount2+ '  '+ " * "
            fill  :amount3,amount3+ '  '+ " * "
            fill  :amount4,amount4+ '  '+ " * "
            fill  :amount5,amount5+ '  '+ " * "
            fill  :amount6,amount6+ '  '+ " * "
            fill  :amount7,amount7+ '  '+ " * "
            fill  :amount8,amount8+ '  '+ " * "
            fill  :amount9,amount9+ '  '+ " * "
            fill  :amount10,amount10+ '  '+ " * "


        end

   elsif  (@pdf_data[:NOTICE_TEXT].present?  and @pdf_data[:NOTICE].action_type == 6572)
          present_amount = sprintf "%.2f", @pdf_data[:PRESENT_RUN_ID].program_benefit_amount
          previous_amount  = sprintf "%.2f", @pdf_data[:PREVIOUS_RUN_ID].program_benefit_amount
        # Rails.logger.debug("@pdf_data[:NOTICE_TEXT]1 = #{present_amount.inspect}")
        # Rails.logger.debug("@pdf_data[:NOTICE_TEXT]2 = #{previous.inspect}")
        notice_text = ''
        if @pdf_data[:PRESENT_RUN_ID].program_benefit_amount == 0.00
          notice_text = "Your monthly benefits will be suspended"
        else
          notice_text = "Your TEA grant will be increased/decreased from:" +' '+ '$'+previous_amount + ' TO '+ '$'+present_amount
        end
        if @pdf_data[:TIME_LIMIT].present?
          notice_text = "You have  #{@pdf_data[:TIME_LIMIT]} months remaining in your 24-month eligibility time limit" + "\n"
        end

        if @pdf_data[:NOTICE].action_type == 6572
            if @pdf_data[:NOTICE_TEXT].any?
               @pdf_data[:NOTICE_TEXT].each do |text|
                  unless (text == "true")
                    notice_text += text
                  end
                end
            end
        end

        if notice_text.present? && @pdf_data[:TIME_LIMIT].present?
          fill :Noticetext ,notice_text
        end
        # client who is turning 19
            fill  :Household, "           HOUSEHOLD    MEMBERS    AFFECTED    BY    THIS    ACTION             "
            # if @pdf_data.age == 19
            # Rails.logger.debug("@pdf_data[:PROGRAM_BENFIT_MEMBERS] = #{@pdf_data[:PROGRAM_BENFIT_MEMBERS].inspect}")
            program_benfit_members = ''
            @pdf_data[:PROGRAM_BENFIT_MEMBERS].each do |program_members|
                  client_name = Client.get_client_full_name_from_client_id(program_members)
                  # Rails.logger.debug("client_name = #{client_name.inspect}")
                  program_benfit_members += client_name.ljust(87)
                 # Rails.logger.debug("program_benfit_members = #{program_benfit_members.inspect}")
                  fill  :membername, "Name"  + '  '.ljust(110) + "Name"
                  #        fill  :memberdetails, first_name + ' ' +@pdf_data.last + '                             ' +"TURNED AGE 19"
                  fill  :memberdetails, program_benfit_members
            end

            fill  :eligibility, "***  YOUR   ELIGIBILITY   WAS   DETERMINED   AS    SHOWN   BELOW ***"
            fill  :eligibilityline1, "GROSS EARNED "
            fill  :eligibilityline2, "WORK DEDUCTION   "
            fill  :eligibilityline3, "INCENTIVE DEDUCTION "
            fill  :eligibilityline4, "NET INCOME  "
            fill  :eligibilityline5, "TOTAL UNEEARNED  "
            fill  :eligibilityline6, "TOTAL ADJUSTED INCOME "
            fill  :eligibilityline7, "FULL BENEFIT "
            fill  :eligibilityline8, "REDUCTION  "
            fill  :eligibilityline9, "SANCTION "
            fill  :eligibilityline10,"BENIFIT AMOUNT "
            fill  :dollar,"$"
            amount1 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_gross_earned
            amount2 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_work_deduct
            amount3 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_incent_deduct
            amount4 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_net_income
            amount5 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_tot_unearned
            amount6 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].eligibility_tot_adjusted
            amount7 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].full_benefit
            amount8 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].reduction
            amount9 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].sanction
            amount10 = sprintf "%.2f", @pdf_data[:PROGRAM_BENEFIT_DETAILS].program_benefit_amount

            fill  :amount1,amount1+ '  '+ " * "
            fill  :amount2,amount2+ '  '+ " * "
            fill  :amount3,amount3+ '  '+ " * "
            fill  :amount4,amount4+ '  '+ " * "
            fill  :amount5,amount5+ '  '+ " * "
            fill  :amount6,amount6+ '  '+ " * "
            fill  :amount7,amount7+ '  '+ " * "
            fill  :amount8,amount8+ '  '+ " * "
            fill  :amount9,amount9+ '  '+ " * "
            fill  :amount10,amount10+ '  '+ " * "
    end

    @pdf_data[:NOTICE].update_column(:notice_status, "6613")
    end
  end