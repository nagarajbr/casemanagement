class Reeval < FillablePdfForm
	def initialize(arg_object)
	    @pdf_data = arg_object
	    super()
	end

	protected

	def fill_out
		first = @pdf_data.firstname.upcase

		#client Address
	    fill  :Clientfirstandlastname, first + ' ' +@pdf_data.lastname.upcase
	    fill :ClientAddressLine1, @pdf_data.address_line1.upcase
	    if @pdf_data.address_line2.present?
	        fill :ClientAddressLine2,  @pdf_data.address_line2.upcase
	        fill :ClientAddressLine3,@pdf_data.city.upcase + '  ' +CodetableItem.get_short_description(@pdf_data.state).upcase + '  ' +@pdf_data.zip
	    else
	        fill :ClientAddressLine2, @pdf_data.city.upcase  + '  ' +CodetableItem.get_short_description(@pdf_data.state).upcase + '  ' +@pdf_data.zip
	    end

	    # county Adderss
	    fill  :Addressline1, CodetableItem.get_short_description(@pdf_data.processing_location).upcase
	    fill :AddressLine2, @pdf_data.mailing_address1.upcase
      	if @pdf_data.mailing_address2.present?
        	fill :AddressLine3,  @pdf_data.mailing_address2.upcase
         	fill :AddressLine4, CodetableItem.get_short_description(@pdf_data.mailing_address_city).upcase  + '  ' +CodetableItem.get_short_description(@pdf_data.mailing_address_state).upcase + '  ' +@pdf_data.mailing_address_zip + '-' +@pdf_data.mailing_address_zip_suffix
      	else
        	fill :AddressLine3, CodetableItem.get_short_description(@pdf_data.mailing_address_city).upcase  + '  ' +CodetableItem.get_short_description(@pdf_data.mailing_address_state).upcase + '  ' +@pdf_data.mailing_address_zip + '-' +@pdf_data.mailing_address_zip_suffix
      	end

      	#caseworker
	    fill :Notice, Date.today
	    # fill :Action, @pdf_data.action_date
	    a = Date.today + 1.months
        month_end_date = a.end_of_month
	    fill :Appeal, month_end_date
	    if @pdf_data.phone_number.present?
		    phone = @pdf_data.phone_number.to_s
		    phone = phone[0,3]+'-'+phone[3,3]+'-'+phone[6,4]
		end
	    fill :phone, phone
	    fill :casenumber,@pdf_data.id
	    fill :CASEWORKER, User.find(@pdf_data.updated_by).name.upcase
	    # fill :Noticetext ,@pdf_data.notice_text
	    # fill :Grant ,"YOUR TEA GRANT WILL BE DECREASED FROM .... TO ...."




	end
end