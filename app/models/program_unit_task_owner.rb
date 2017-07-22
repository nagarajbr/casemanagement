class ProgramUnitTaskOwner < ActiveRecord::Base
  has_paper_trail :class_name => 'PguTaskOwnerVersion',:on => [:update, :destroy]
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

    def self.set_program_unit_task_owner(arg_program_unit_id,arg_ownership_type,arg_ownership_user_id)
        program_unit_task_owner = nil
        program_unit_task_owners = where("program_unit_id =? and ownership_type = ?",arg_program_unit_id,arg_ownership_type)
        if program_unit_task_owners.blank?
            program_unit_task_owner = ProgramUnitTaskOwner.new
            program_unit_task_owner.program_unit_id = arg_program_unit_id
            program_unit_task_owner.ownership_type = arg_ownership_type
            program_unit_task_owner.ownership_user_id = arg_ownership_user_id
        else
            program_unit_task_owner = program_unit_task_owners.first
            program_unit_task_owner.ownership_user_id = arg_ownership_user_id
        end
        program_unit_task_owner.save!
        return program_unit_task_owner
    end

    def self.get_program_unit_task_owner(arg_program_unit_id,arg_ownership_type)
        program_unit_task_owners = where("program_unit_id =? and ownership_type = ?",arg_program_unit_id,arg_ownership_type)
        if program_unit_task_owners.present?
            return program_unit_task_owners.first
        else
            return nil
        end
    end

    def self.get_task_owners_related_to_program_unit_and_selected_ownership_type(arg_program_unit_id)
        where("program_unit_id = ? and ownership_type in (6617,6619,6623,6618)",arg_program_unit_id)
    end
end