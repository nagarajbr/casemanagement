class PreScreening < ActiveRecord::Base
	# 	include AuditModule




  attr_accessor :first_name, :middle_name,:last_name,:suffix,:ssn,:dob,:gender,:citizenship,:veteran_flag






         #Manoj 09/06/2014
    # pre screening Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps

       %w[pre_screening_first pre_screening_second pre_screening_third pre_screening_fourth pre_screening_fifth pre_screening_last]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end


    def get_process_object
      self.process_object = steps[steps.index(current_step)-1]
    end


    # pre screening Multi step form creation of data. - - End



    # def self.get_pre_processing_collection(arg_client_id)
    # 	where("client_id = ?",arg_client_id )
    # end

    # def self.create_new_pre_screening()
    # 	l_object = PreScreening.new
    #   l_object.created_by = 1
    #   l_object.updated_by = 1
   	# 	l_object.save
   	# 	return l_object
    # end

    # def self.save_data_to_phone_table(arg_pre_screening_id)
    #   pre_screening_object = PreScreening.find(arg_pre_screening_id)

    #   if pre_screening_object.primary_phone.present?

    #      phone_collection = Phone.where("client_id = ? and phone_type = ?",pre_screening_object.client_id,pre_screening_object.primary_phone)

    #      if phone_collection.present?
    #         # update
    #         phone_object = phone_collection.first
    #         phone_object.client_id = pre_screening_object.client_id
    #         phone_object.phone_type = 4661
    #         phone_object.number = pre_screening_object.primary_phone

    #      else
    #         # insert
    #         phone_object = Phone.new
    #         phone_object.client_id = pre_screening_object.client_id
    #         phone_object.phone_type = 4661
    #         phone_object.number = pre_screening_object.primary_phone
    #      end
    #       phone_object.save
    #   end
    # end




    # def self.lock_pre_processing?(arg_pre_screening_id)
    #   # if the client id associated with pre screening ID is involved in Application ID means
    #   # this pre screening is converted to Application- so no changes should be allowed at pre screening level
    #   #  for that client - manage his changes in other client screen.
    #   pre_screening_object = PreScreening.find(arg_pre_screening_id)
    #   if pre_screening_object.present?
    #     if ApplicationMember.where("client_id = ?",pre_screening_object.client_id).present?
    #       lb_return = true
    #     else
    #       lb_return = false
    #     end
    #   else
    #     lb_return = false
    #   end
    #   return lb_return
    # end


    # def self.save_address_tables(arg_pre_screening_id)
    #   pre_screening_object = PreScreening.find(arg_pre_screening_id)
    #   #  get client ID
    #   if pre_screening_object.present?
    #     client_object = Client.find(pre_screening_object.client_id)
    #     #  get the latest mailing address for client?
    #     client_addr_collection = ClientAddress.where("client_id = ?",client_object.id)
    #     if client_addr_collection.present?
    #       # Address is found in the system for this client - so update the address.
    #       # find the latest mailing address
    #       step1 = Address.joins("INNER JOIN client_addresses ON addresses.id = client_addresses.address_id")
    #       step2 = step1.where("addresses.address_type = 4665")
    #       addr_cl_join_collection = step2.order("addresses.id DESC")
    #       if addr_cl_join_collection.present?
    #          mail_addr_object = addr_cl_join_collection.first
    #          #  copy this address to Prior mailing address.
    #          prior_addr_object = Address.new
    #          prior_addr_object.address_line1 = mail_addr_object.address_line1
    #          prior_addr_object.address_line2 = mail_addr_object.address_line2
    #          prior_addr_object.city = mail_addr_object.city
    #          prior_addr_object.state = mail_addr_object.state
    #          prior_addr_object.zip = mail_addr_object.zip
    #          prior_addr_object.address_type = 4666 # prior mailing
    #          prior_addr_object.save

    #          cl_addr_prior_object = ClientAddress.new
    #          cl_addr_prior_object.client_id = client_object.id
    #          cl_addr_prior_object.address_id = prior_addr_object.id

    #          # Update the current address.
    #          mail_addr_object.address_line1 = pre_screening_object.mailing_address_line1
    #          mail_addr_object.address_line2 = pre_screening_object.mailing_address_line2
    #          mail_addr_object.city = pre_screening_object.mailing_address_city
    #          mail_addr_object.state = pre_screening_object.mailing_address_state
    #          mail_addr_object.zip = pre_screening_object.mailing_zip_code
    #          mail_addr_object.save
    #       end
    #       # find the latest residence address

    #       step1 = Address.joins("INNER JOIN client_addresses ON addresses.id = client_addresses.address_id")
    #       step2 = step1.where("addresses.address_type = 4664")
    #       addr_cl_join_collection = step2.order("addresses.id DESC")
    #       if addr_cl_join_collection.present?
    #          res_addr_object = addr_cl_join_collection.first
    #          #  copy this address to Prior mailing address.
    #          prior_addr_object = Address.new
    #          prior_addr_object.address_line1 = res_addr_object.address_line1
    #          prior_addr_object.address_line2 = res_addr_object.address_line2
    #          prior_addr_object.city = res_addr_object.city
    #          prior_addr_object.state = res_addr_object.state
    #          prior_addr_object.zip = res_addr_object.zip
    #          prior_addr_object.address_type = 5769 # prior residence
    #          prior_addr_object.save

    #          cl_addr_prior_object = ClientAddress.new
    #          cl_addr_prior_object.client_id = client_object.id
    #          cl_addr_prior_object.address_id = prior_addr_object.id

    #          # Update the current address.
    #          res_addr_object.address_line1 = pre_screening_object.res_address_line1
    #          res_addr_object.address_line2 = pre_screening_object.res_address_line2
    #          res_addr_object.city =  pre_screening_object.res_address_city
    #          res_addr_object.state = pre_screening_object.res_address_state
    #          res_addr_object.zip =  pre_screening_object.res_zip_code
    #          res_addr_object.save
    #       end

    #     else # No address found for this client in the system
    #        mail_addr_object = Address.new
    #        mail_addr_object.address_line1 = pre_screening_object.mailing_address_line1
    #        mail_addr_object.address_line2 = pre_screening_object.mailing_address_line2
    #        mail_addr_object.city = pre_screening_object.mailing_address_city
    #        mail_addr_object.state = pre_screening_object.mailing_address_state
    #        mail_addr_object.zip = pre_screening_object.mailing_zip_code
    #        mail_addr_object.address_type = 4665
    #        mail_addr_object.save
    #        # Save
    #        # client_address table
    #        cl_mail_addr_object = ClientAddress.new
    #        cl_mail_addr_object.client_id = client_object.id
    #        cl_mail_addr_object.address_id = mail_addr_object.id
    #        cl_mail_addr_object.save


    #        # Residence address
    #         res_addr_object = Address.new
    #         res_addr_object.address_line1 =  pre_screening_object.res_address_line1
    #         res_addr_object.address_line2 =  pre_screening_object.res_address_line2
    #         res_addr_object.city =  pre_screening_object.res_address_city
    #         res_addr_object.state =  pre_screening_object.res_address_state
    #         res_addr_object.zip =  pre_screening_object.res_zip_code
    #         res_addr_object.address_type = 4664
    #         res_addr_object.save

    #          # client_address table
    #        cl_mail_addr_object = ClientAddress.new
    #        cl_mail_addr_object.client_id = client_object.id
    #        cl_mail_addr_object.address_id = res_addr_object.id
    #        cl_mail_addr_object.save

    #     end

    #   end # end of pre_processing_object.present
    # end


  #   def self.manage_client_pre_screening(arg_params)
  #     return_hash = {}

  #     #  if SSN is found update the client record.
  #     client_object_collection = Client.where("ssn = ?", arg_params[:ssn])
  #     if client_object_collection.present?
  #       #  update client data.
  #       # Audit Table?
  #       # Need to be discussed - can we overwrite client information - if somebody makes mistake in typing SSN -
  #       #  show flash message SSN is already found in the system -
  #       client_obj = client_object_collection.first
  #     else
  #      client_obj = Client.new
  #     end

  #     # set data
  #     client_obj.first_name = arg_params[:first_name]
  #     client_obj.middle_name = arg_params[:middle_name]
  #     client_obj.last_name = arg_params[:last_name]
  #     client_obj.suffix = arg_params[:suffix]
  #     client_obj.dob = arg_params[:dob]
  #     client_obj.gender = arg_params[:gender]
  #     client_obj.citizenship = arg_params[:citizenship]
  #     client_obj.veteran_flag = arg_params[:veteran_flag]

  #     begin
  #         ActiveRecord::Base.transaction do
  #           client_obj.save!
  #         end
  #           return_hash[:message] = "SUCCESS"
  #           message = "SUCCESS"
  #     rescue => err
  #          return_hash[:message] =  err.message
  #     end
  #     return_hash[:client_obj] = client_obj

  #     return return_hash
  # end






end

