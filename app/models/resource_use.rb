class ResourceUse < ActiveRecord::Base
has_paper_trail :class_name => 'ResourceUseVersion' ,:on => [:update, :destroy]
include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
	 belongs_to :resource_detail

	 validates_presence_of :usage_code,message: "is required"

	HUMANIZED_ATTRIBUTES = {
    :usage_code => "Usage Code"
    }



	def self.human_attribute_name(attr, options = {})
		HUMANIZED_ATTRIBUTES[attr.to_sym] || super
	end

	def set_create_user_fields
	    user_id = AuditModule.get_current_user.uid
	    self.created_by = user_id
	    self.updated_by = user_id
	end

	def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
	end

	def self.get_resource_uses_for_resource_detail(arg_resource_detail_id)
		where("resource_details_id = ?",arg_resource_detail_id).order("id DESC")
	end

	def self.resource_uses_found_for_the_given_resource_detail_id?(arg_resource_detail_id)
      step1 = ResourceUse.where("resource_uses.resource_details_id = ?",arg_resource_detail_id)
      if step1.present?
        return true
      else
        return false
      end
    end
end
