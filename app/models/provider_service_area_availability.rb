class ProviderServiceAreaAvailability < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderAreaAvailVersion',:on => [ :delete,:update]



	include AuditModule


 	before_create :set_create_user_fields
  	before_update :set_update_user_field

  	 HUMANIZED_ATTRIBUTES = {
    :day_of_the_week => "Day of the Week",
    :start_time_5i => "Start Time",
    :end_time_5i => "End Time",

    }

     validates_uniqueness_of :day_of_the_week, :scope => [:provider_service_area_id],message: "is already saved"
     validate :start_time_less_than_end_time?
     validates_presence_of :day_of_the_week, message: "is required"

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

    # def self.get_provider_service_and_area_for_area_id(arg_area_id)
    #   step1 = ProviderService.joins("INNER JOIN provider_service_areas ON provider_service_areas.provider_service_id = provider_services.id")
    #   step2 = step1.where("provider_service_areas.id = ?", arg_area_id)
    #   step3 = step2.select("provider_services.service_type,provider_service_areas.area_zip")
    #   return_object = step3.first
    #   return return_object
    # end

    def start_time_less_than_end_time?
      if self.end_time.present?
        if start_time > end_time
            errors[:base] << "End time should be after start time"
            return false
          else
            return true
          end
      end
    end
end
