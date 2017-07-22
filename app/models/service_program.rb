
class ServiceProgram < ActiveRecord::Base
has_paper_trail :class_name => 'ServiceProgramVersion',:on => [:update, :destroy]


	before_create :set_create_user_fields
  before_update :set_update_user_field
	# Author : Manojkumar PAtil
	# Date : 08/21/2014



	 # has_many :application_service_programs
	 # This sets up join between service_programs,client_applications,application_service_programs table.
  	 # has_many :client_applications, through: :application_service_programs
  	 # has_one :client_application, through: :application_service_programs



	# show description for given ID.
	def self.service_program_name(arg_id)
		where(id: arg_id).first.title
	end

	def self.item_list()
	  	self.all.order("title")
  end


  def self.service_program_description(arg_id)
    where(id: arg_id).first.description
  end

  def self.get_service_programs_for_category_id(arg_category_id)
    where("svc_pgm_category = ?", arg_category_id)
  end


  def set_create_user_fields
    # user_id = AuditModule.get_current_user.uid
    self.created_by = 1 #user_id - systemadmin
    self.updated_by = 1 #user_id
  end

  def set_update_user_field
    # user_id = AuditModule.get_current_user.uid
    self.updated_by = 1 #user_id
  end

  def self.get_category(arg_category_id)
    if arg_category_id.present?
      find(arg_category_id).title
    else
      return ""
    end
  end

  def self.get_tanf_service_programs
    where("svc_pgm_category = 6015")
  end

  def self.get_sanctioned_tanf_service_programs
    where("id in (1,4)")
  end

end
