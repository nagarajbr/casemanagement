class Tea1 < FillablePdfForm

  def initialize(arg_object)
    @pdf_data = arg_object
    super()
  end

  protected

  def fill_out

    first = @pdf_data.primary_first_name
    # first_name = @pdf_data.member_first_name

# #client Address
     fill  :Clientfirstandlastname, first + ' ' +@pdf_data.primary_last_name
    fill :ClientAddressLine1, @pdf_data.primary_member_addr_line1
    if @pdf_data.primary_member_addr_line2.present?
        fill :ClientAddressLine2,  @pdf_data.primary_member_addr_line2
         fill :ClientAddressLine3,@pdf_data.primary_member_addr_city+ '  ' +CodetableItem.get_short_description(@pdf_data.primary_member_addr_state)+ '  ' +@pdf_data.primary_member_addr_zip

      else
        fill :ClientAddressLine2, @pdf_data.primary_member_addr_city + '  ' +CodetableItem.get_short_description(@pdf_data.primary_member_addr_state)+ '  ' +@pdf_data.primary_member_addr_zip

      end


# county Adderss
    fill  :Addressline1, CodetableItem.get_short_description(@pdf_data.processing_location)
    fill :AddressLine2, @pdf_data.local_office_addr_line1
      if @pdf_data.local_office_address2.present?
        fill :AddressLine3,  @pdf_data.local_office_address2
         fill :AddressLine4, CodetableItem.get_short_description(@pdf_data.local_office_addr_city) + '  ' +CodetableItem.get_short_description(@pdf_data.local_office_addr_state)+ '  ' +@pdf_data.local_office_addr_zip + '-' +@pdf_data.local_office_addr_zip_suffix

      else
        fill :AddressLine3, CodetableItem.get_short_description(@pdf_data.local_office_addr_city) + '  ' +CodetableItem.get_short_description(@pdf_data.local_office_addr_state)+ '  ' +@pdf_data.local_office_addr_zip + '-' +@pdf_data.local_office_addr_zip_suffix

      end
#caseworker
    fill :Notice, @pdf_data.status_date
    fill :Action, @pdf_data.action_date
    fill :Appeal, @pdf_data.date
    if  @pdf_data.phone_number.present?
    phone = @pdf_data.phone_number.to_s
    phone = phone[0,3]+'-'+phone[3,3]+'-'+phone[6,4]
    fill :phone, phone
  end
    fill :casenumber,@pdf_data.id
    fill :CASEWORKER, User.find(@pdf_data.updated_by).name
    notice_texts  = NoticeText.where("action_type = ? and action_reason = ? "  ,@pdf_data.status,@pdf_data.reason)
    notice_texts.each do |notice|
    notices = notice.notice_text

    fill :Noticetext ,notices


    # fill :Grant , CodetableItem.get_short_description(@pdf_data.reason)



     if  notice.flag2 == true
# client who is turning 19
       fill  :Household, "           HOUSEHOLD    MEMBERS    AFFECTED    BY    THIS    ACTION             "
#       fill  :membername, "NAME                                                  REASON"
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

       # fill  :memberdetails, client.first_name +  ' ' + client.last_name
    end
     fill  :membername, clients
      end

    if  notice.flag1 == true
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
end
