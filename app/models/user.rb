require "gds-sso/user"

class User < ActiveRecord::Base
  include GDS::SSO::User
  after_create :add_user_local_office

  # 1.
    def get_role_id()
        role_array = self.permissions
        if role_array.present?
           if role_array.include?('Manager')
            return 6
          end
          if role_array.include?('Supervisor')
            return 5
          end
          if role_array.include?('Specialist')
            return 3
          end
        else
          # Lowest Role is specialist. if old data with no permission comes in specialist is returned.
          return 3
        end

    end


     # 1.
    def get_role_id_desc()
       li_role_id = get_role_id()
        case li_role_id
        when 6
           return 'Manager'
        when 5
           return 'Supervisor'
        when 3
           return 'Specialist'
        else
          return ' '
        end
    end

    def add_user_local_office
      get_user_object = User.find(id)
       if get_user_object.organisation_slug.present?
          user_local_office_object = UserLocalOffice.new
          user_local_office_object.user_id = get_user_object.uid
          local_office_collection = CodetableItem.get_codetable_items_id(2,get_user_object.organisation_slug)
          if local_office_collection.present?
            local_office_id = local_office_collection.first.id
            user_local_office_object.local_office_id = local_office_id
            user_local_office_object.save
          end
       end
    end

    def self.get_user_full_name(arg_uid)
      user_collection = User.where("uid = ?",arg_uid.to_s)
      if user_collection.present?
        user_object = user_collection.first
        return user_object.name
      else
        return ' '
      end
    end


end
