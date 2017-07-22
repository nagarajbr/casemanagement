class Comment < ActiveRecord::Base

    before_create :set_create_user_fields
    before_update :set_update_user_field

    HUMANIZED_ATTRIBUTES = {
      subject: "What you were doing",
      comment: "What went wrong"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_presence_of :subject, :comment, message: "is required"

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

end
