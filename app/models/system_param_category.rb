class SystemParamCategory  < ActiveRecord::Base
has_paper_trail :class_name => 'SystmParmCategoryVersion',:on => [:update, :destroy]

  has_many :system_params, dependent: :destroy
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

    def self.get_system_param_records_for_category(arg_category_id)
      SystemParam.where("system_param_categories_id = ?",arg_category_id).order("description asc")
    end
end