class AttopAncestorController < ApplicationController

	before_action :set_logged_in_user_in_audit_module

	private
		def set_logged_in_user_in_audit_module

			AuditModule.set_current_user=(current_user)
			# Rails.logger.debug("MNP-set_logged_in_user_in_audit_module = #{current_user.inspect}")
		end

		def set_household_member_info_in_session(arg_client_id)
			household_member = HouseholdMember.get_household_member_object_for_client(arg_client_id)
			if household_member.present?
				session[:HOUSEHOLD_ID] = household_member.household_id
				# session[:HOUSEHOLD_MEMBER_ID] = household_member.id
			end
		end


		def set_hoh_data(arg_client_id)
			@household = nil
	  		household_member = HouseholdMember.get_household_member_object_for_client(arg_client_id)
			if household_member.present?
				@household = Household.find(household_member.household_id)
			end
		end


end

