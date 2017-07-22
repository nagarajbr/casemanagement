class ClientDocVerfication < ActiveRecord::Base
	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field

	has_many :codetable_items

	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
      self.document_verfied_date = Time.now.to_date
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
      self.document_verfied_date = Time.now.to_date
    end


    def self.create_multiple_records(arg_params,arg_client_id)
 #    	{"utf8"=>"✓",
		 # "authenticity_token"=>"Cd8tPZsd8SCVih3G1NMPhr/Y2jktzcarObIh6GWlck4=",
		 # "client_doc_verification"=>{"codetable_item_ids"=>["6023",
		 # "6022",
		 # "6020",
		 # "6021",
		 # "6024"]},
 # "commit"=>"Save"}
    	#  capture list of selected documents from hash
    	l_doc_type_array = arg_params[:codetable_item_ids]
    	l_param = {}

    	#  for errror handling
    	ls_error_message = "NONE"
    	l_error_message_array = Array.new
    	#  loop through and save records.
    	l_doc_type_array.each do |doc_type|
    		l_param[:client_id] = arg_client_id
    		l_param[:document_type] = doc_type
    		l_object = ClientDocVerfication.create(l_param)
    		if l_object.errors.full_messages.present?
    			l_object.errors.full_messages.each do |l_msg|
    				l_error_message_array << l_msg
    			end
    		end
    	end

    	if l_error_message_array.size > 0
    		return l_error_message_array
    	else
    		ls_error_message = "NONE"
    	end

    end

    def self.update_multiple_records(arg_params)
    	arg_params.each do |doc_param|
    		ClientDocVerfication.update(doc_param)
    	end
    end

     def self.doc_verification_params(arg_params)
	 	return_params= {}
	 	if arg_params[:client_doc_verification].present?
			return_params = arg_params.require(:client_doc_verification).permit(codetable_item_ids:[])
		end
		return return_params
  	 end


  	def self.get_verified_documents(arg_application_id)
  		result_collection = ClientDocVerfication.where("client_id in ( select client_id from application_members where client_application_id = ?)",arg_application_id)
  	end

end
