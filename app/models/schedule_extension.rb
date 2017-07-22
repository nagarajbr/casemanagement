class ScheduleExtension < ActiveRecord::Base
has_paper_trail :class_name => 'ScheduleExtensionVersion',:on => [:update, :destroy]


	include AuditModule

    before_create :set_create_user_fields
    before_update :set_update_user_field

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id

    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    belongs_to :schedule

    validates_presence_of :extension_duration, message: "is required"

    def self.get_schedule_extension_from_schedule_id(arg_schedule_id)
        ScheduleExtension.where("schedule_id = ?",arg_schedule_id)


    end
end
