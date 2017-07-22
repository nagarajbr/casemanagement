class LocalOfficeInformation < ActiveRecord::Base
	include AuditModule
 # 	before_create :set_create_user_fields
	# before_update :set_update_user_field
 #  	def set_create_user_fields
 #      user_id = AuditModule.get_current_user.id
 #      self.created_by = user_id
 #      self.updated_by = user_id
 #    end

 #    def set_update_user_field
 #      user_id = AuditModule.get_current_user.id
 #      self.updated_by = user_id
 #    end

    def self.local_office_informations_details_from_codetable_items_id(arg_id)
    	result = LocalOfficeInformation.where("code_table_item_id = ?",arg_id)
  	  if result.present?
  	  	 noticetext = result.select("local_office_informations.*")
         return noticetext
  	  else
  	  	 return ""
  	  end

    end
end
