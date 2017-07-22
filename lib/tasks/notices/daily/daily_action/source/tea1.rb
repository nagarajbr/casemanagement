class Tea1 < FillablePdfForm

  def initialize(arg_object)
    @pdf_data = arg_object
    super()
  end

  protected

  def fill_out

    first = @pdf_data.first_name

#client Address
    fill  :Clientfirstandlastname, first + ' ' +@pdf_data.last_name
    fill :ClientAddressLine1, @pdf_data.address_line1
    if @pdf_data.address_line2.present?
        fill :ClientAddressLine2,  @pdf_data.address_line2
         fill :ClientAddressLine3,@pdf_data.city+ '  ' +CodetableItem.get_short_description(@pdf_data.state)+ '  ' +@pdf_data.zip

      else
        fill :ClientAddressLine2, @pdf_data.city + '  ' +CodetableItem.get_short_description(@pdf_data.state)+ '  ' +@pdf_data.zip

      end


# county Adderss
    fill  :Addressline1, CodetableItem.get_short_description(@pdf_data.processing_location)
    fill :AddressLine2, @pdf_data.mailing_address1
      if @pdf_data.mailing_address2.present?
        fill :AddressLine3,  @pdf_data.mailing_address2
         fill :AddressLine4, CodetableItem.get_short_description(@pdf_data.mailing_address_city) + '  ' +CodetableItem.get_short_description(@pdf_data.mailing_address_state)+ '  ' +@pdf_data.mailing_address_zip + '-' +@pdf_data.mailing_address_zip_suffix

      else
        fill :AddressLine3, CodetableItem.get_short_description(@pdf_data.mailing_address_city) + '  ' +CodetableItem.get_short_description(@pdf_data.mailing_address_state)+ '  ' +@pdf_data.mailing_address_zip + '-' +@pdf_data.mailing_address_zip_suffix

      end
#caseworker
    fill :Notice, @pdf_data.status_date
    fill :Action, @pdf_data.action_date
    fill :Appeal, @pdf_data.date
    phone = @pdf_data.phone_number.to_s
    phone = phone[0,3]+'-'+phone[3,3]+'-'+phone[6,4]
    fill :phone, phone
    fill :casenumber,@pdf_data.id
    fill :CASEWORKER, User.find(@pdf_data.updated_by).name
    fill :Noticetext ,@pdf_data.notice_text
    # fill :Grant ,"YOUR TEA GRANT WILL BE DECREASED FROM .... TO ...."



    if @pdf_data.flag2 == true
# client who is turning 19
     fill  :Household, "           HOUSEHOLD    MEMBERS    AFFECTED    BY    THIS    ACTION             "
        if @pdf_data.age == 19

          fill  :membername, "NAME                                                  REASON"
          fill  :memberdetails,  @pdf_data.first + ' ' +@pdf_data.last + '                             ' +"TURNED AGE 19"
        else
          client_name  = ProgramUnit.get_clients_name_from_program_unit_id(@pdf_data.id)
          clients = ''
          count = 1
          client_name.each do |client|
          clients = clients + "#{client.first}" + ' ' + "#{client.last} "
          if count < 2
            clients = clients + ' '.ljust(70,' ')
            count = count + 1
          else
            clients = clients + "\n"
            count = 1
          end
           fill  :membername, clients
        end
    end
  end


    # fill  :membername, "NAME                                                  REASON"
    # fill  :memberdetails, first_name + ' ' +@pdf_data.last + '                             ' +"TURNED AGE 19"

    #   end

    if @pdf_data.flag1 == true
        fill  :eligibility, "***  YOUR   ELIGIBILITY   WAS   DETERMINED   AS    SHOWN   BELOW ***      "
        fill  :eligibilityline1, " SOCIAL SECURITY INCOME                               " +'         .00 '+  " *GROSS EARNINGS                                 " + '         .00 *'
        fill  :eligibilityline2, "CONTRIBUTIONS                                                 " +'         .00'+  " *DEDUCTIONS                                           " + '         .00 *'
        fill  :eligibilityline3, "STEPPARENT INCOME                                       " +'         .00 '+  " *CHILD CARE                                             " + '         .00 *'
        fill  :eligibilityline4, " VA PENSON                                                          " +'         .00 '+  " *EXCLUSIONS                                            " + '         .00 *'
        fill  :eligibilityline5, " VA COMPENSTION                                              " +'         .00 '+  " *NET EARNED INCOME                            " + '         .00 *'
        fill  :eligibilityline6, " RAILROAD RETIREMENT                                    " +'         .00 '+  " *MAXIMUM BENEFIT AMOUNT                 " + '         .00 *'
        fill  :eligibilityline7, " OTHER UNEARNED INCOME                              " +'         .00 '+  " *NETCOUNTABLE INCOME                      " + '         .00 *'
        fill  :eligibilityline8, " TOTAL UNEARNED INCOME                               " +'         .00 '+  " *TEA CHECK AMOUNT                             " + '         .00 *'
    end


  end
end
