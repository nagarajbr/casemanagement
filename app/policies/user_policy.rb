class UserPolicy < ApplicationPolicy
  #Author : Manoj Patil
  #Date : 07/08/2014
  #Description : All Authorization Rules for Users controller
  # Rule 1 : Only User's with 'System Support ' role have access to controller actions
  #          show,create,update
    # Rule 2 : Only User's with 'System Support ' role can update following fields
  #         [:login,:title,:name,:phone_number,:email_id,:location,:county,:division_code,:cpu,:asis_emp_num,:active_directory_id,:status,:language, role_ids: []]
  # Rule 3 : Non Admin/ all Logged in Users can update their password,
  #          So Non Admin users have permission to update fields : Password,password_confirmation only.


    def show?
      allow_system_support_only?
    end

    def create?
      allow_system_support_only?
    end


    def update?
      allow_system_support_only?
    end

    # def system_lock_unlock?
    #   allow_system_admin_only?
    # end

    # def system_lock_unlock_update?
    #   allow_system_admin_only?
    # end



   # def allow_system_support_only?
   #    if user.system_support_role?
   #        true
   #    else
   #        false
   #    end
   # end

  # def allow_system_admin_only?
  #     if user.system_admin_role?
  #         true
  #     else
  #         false
  #     end
  # end

  # logged in user can do this action.
  def change_password?
  true
  end

  def update_password?
  true
  end

  # def permitted_attributes
  #   if user.system_support_role?
  #     [:login,:title,:name,:phone_number,:reports_to,:phone_term,:email,:location,:county,:division_code,:language,:cpu,:asis_emp_num,:active_directory_id,:role_ids]

  #   end
  # end

  # def permitted_update_attributes
  #   if user.system_support_role?
  #     [:login,:title,:name,:phone_number,:reports_to,:phone_term,:email,:location,:county,:division_code,:language,:cpu,:asis_emp_num,:active_directory_id,:status,:role_ids]
  #   end
  # end

end