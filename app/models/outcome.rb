class Outcome < ActiveRecord::Base
has_paper_trail :class_name => 'OutcomeVersion',:on => [:update, :destroy]


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


    def self.get_outcome_data(arg_reference_id)
        where("reference_id = ?",arg_reference_id)
    end

    def self.get_outcome_object(arg_reference_id, arg_entity_type)
        where("reference_id = ? and outcome_entity = ?",arg_reference_id,arg_entity_type)
    end

    validates_presence_of :outcome_code, message: "is required."
end
