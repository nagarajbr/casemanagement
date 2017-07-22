class ClientDocVerfication < ActiveRecord::Base
has_paper_trail :class_name => 'ClientDocVerficationVersion',:on => [:update, :destroy]

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field

	# has_many :codetable_items
	validates :client_id, :document_type, presence: true

	HUMANIZED_ATTRIBUTES = {
      client_id: "Member",
      document_type: "Document Type",
      document_verfied_date: "Document Verified Date"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

       # instantiate Date service object
    # after_initialize do |obj|
    #   @l_date_object = DateService.new
    # end

    validate :valid_document_verfied_date?

    def valid_document_verfied_date?
        DateService.valid_date_before_today?(self,document_verfied_date,"Document Verified Date")
    end


	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
      # self.document_verfied_date = Time.now.to_date
    end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
    # self.document_verfied_date = Time.now.to_date
  end

  def self.get_verified_documents(arg_application_id)
    result_collection = ClientDocVerfication.where("client_id in ( select client_id from application_members where client_application_id = ?)",arg_application_id)
  end

  # def self.any_verification_documents_for_application?(arg_application_id)
  #   	lb_return = false
  #   	result_collection = ClientDocVerfication.where("client_id in ( select client_id from application_members where client_application_id = ?)",arg_application_id)
  #   	if  result_collection.size > 0
  #   		lb_return = true
  #   	else
  #   		lb_return = false
  #   	end
  # 	 return lb_return
  # end

  def self.get_program_unit_verified_documents(arg_program_unit_id)
  	 result_collection = ClientDocVerfication.where("client_id in ( select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id)
  end

  # def self.any_verification_documents_for_program_unit?(arg_program_unit_id)
  #     	lb_return = false
  #     	result_collection = ClientDocVerfication.where("client_id in ( select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id)
  #   	if  result_collection.size > 0
  #   		lb_return = true
  #   	else
  #   		lb_return = false
  #   	end
  #   	return lb_return

  # end

  def self.focus_client_documents(arg_client_id)
  	client_document_collections = self.where("client_id = ?",arg_client_id)
  end



end
