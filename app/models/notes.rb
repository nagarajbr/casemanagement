class Notes < ActiveRecord::Base
has_paper_trail :class_name => 'NoteVersion',:on => [:update, :destroy]
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

    # def self.get_client_notes(arg_client_id,arg_entity_type)
    # 	where("entity_id = ? and entity_type = ?",arg_client_id,arg_entity_type).first
    # end

    # def self.get_client_notes_with_clientid_and_notes_type(arg_client_id,arg_notes_type,arg_entity_type)
    #   notes = ""
    #   client_notes = where("entity_id = ? and notes_type=? and entity_type = ? ",arg_client_id,arg_notes_type,arg_entity_type)
    #   if client_notes.present?
    #     notes = client_notes.first
    #   end
    #   return notes
    # end

    # def self.get_household_notes(arg_household_id,arg_entity_type)
    #   where("entity_id = ? and entity_type = ?",arg_household_id,arg_entity_type)
    # end
end
