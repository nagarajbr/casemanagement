class ProviderLanguage < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderLanguageVersion',:on => [:update, :destroy]

	include AuditModule
 	belongs_to :provider
 	before_create :set_create_user_fields
  before_update :set_update_user_field

  # after_initialize do |obj|
  #   @l_date_object = DateService.new
  # end


    HUMANIZED_ATTRIBUTES = {
    :language_type => "Language",
    :start_date => "Start date",
    :end_date => "End date"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_presence_of :language_type, :start_date, message: "is required"
    validate :valid_start_date?,:valid_end_date?,:valid_end_date_greater_than_valid_start_date?
    validate :validate_only_one_active_language?, :on => :create


 	  def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def valid_start_date?
      DateService.valid_date?(self,start_date,"Start date")
    end

    def valid_end_date?
      DateService.valid_date?(self,end_date,"End date")
    end

    def valid_end_date_greater_than_valid_start_date?
      DateService.begin_date_cannot_be_greater_than_end_date?(self,start_date,end_date,"Start date","End date")
    end

    def validate_only_one_active_language?
      if Provider.is_language_present(self.provider_id,self.language_type)
         local_message = "This language exists"
        self.errors[:base] << local_message
        return false
      else
        return true
      end
    end
end
