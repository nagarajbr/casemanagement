class ProviderServiceArea < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderServiceAreaVersion',:on => [:update, :destroy]


	include AuditModule


 	before_create :set_create_user_fields
  	before_update :set_update_user_field

    has_many :provider_service_area_availabilities, dependent: :destroy

  	 HUMANIZED_ATTRIBUTES = {
    :area_zip => "Zip code",
    local_office_id: "Service Area",
    }

    validates_presence_of :local_office_id, message: "is required"

    # validates_length_of :area_zip, minimum:5, maximum:5, message: " of 5 digits is required"
    # validates_uniqueness_of :area_zip, :scope => [:provider_service_id],message: "is already assigned"

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

	def self.get_service_areas_for_provider_service_id(arg_provider_service_id)
		ProviderServiceArea.where("provider_service_id = ?",arg_provider_service_id)
	end

  def self.get_local_offices_already_used(arg_provider_service_id)
    where("provider_service_id = ?",arg_provider_service_id).select("distinct local_office_id")
  end
end
