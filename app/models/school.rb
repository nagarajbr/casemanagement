class School < ActiveRecord::Base
has_paper_trail :class_name => 'SchoolVersion',:on => [:update, :destroy]


	# include AuditModule

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

    validates_presence_of :school_type,:school_name, message: "is required."

    HUMANIZED_ATTRIBUTES = {
        school_name: " School Name",
        school_type: " School Type",
        web_address: " Web Address "
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def self.search(params)
        if params[:school_name].present? && (params[:school_name].length)>1
             self.where("lower(school_name) like ?", "#{params[:school_name]}%".downcase).order("school_name ASC")
        end
    end

    def self.get_school_name(arg_id)
        find(arg_id).school_name
    end
end
