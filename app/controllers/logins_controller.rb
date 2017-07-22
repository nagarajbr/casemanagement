 class LoginsController < ApplicationController
 	def login
 		# Clear all session variables and redirect to search

 		clear_session_variables()

 		redirect_to('/clients/search/new')

 	end

 	def logout

 		# Clear all session variables and redirect to Single Signon
 		clear_session_variables()

 		redirect_to("#{GDS::SSO::Config.oauth_root_url}")

 	end
 	private
 # 	def clear_session_variables()
	# 	session[:CLIENT_ID] = nil
	#     session[:new_application_id] = nil
	#     session[:application_step] = nil
	#     session[:NAVIGATED_FROM] = nil
	#     session[:CALLED_FROM] = nil
	#     session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
	#     session[:NAVIGATE_TO] = nil
	#     session[:user_step] = nil
	#     session[:user_params] = nil
	#     session[:clicked_menu] = nil
	#     session[:NEW_CLIENT_SSN] = nil
	#     session[:APPLICATION_SCREENING_STEP] = nil
	#     session[:NEW_APPLICATION_SCREENING_ID] =  nil
	#     session[:PRIMARY_APPLICANT] = nil

	#     session[:PROGRAM_WIZARD_STEP] = nil
	#     session[:NEW_PROGRAM_WIZARD_ID] = nil
	#     session[:APPLICATION_ID] = nil
	#     session[:PROGRAM_UNIT_ID] = nil
	#     session[:PGU_SAME_AS_APP] = nil
	#     session[:NEW_PRE_SCREENING_ID] = nil
	#     session[:PRE_SCREENING_STEP] = nil
	#     # household_prescreening
	#     session[:HOUSEHOLD_PRE_SCREENING_ID] = nil
	#     session[:HOUSEHOLD_PRE_SCREENING_STEP] = nil
	#     session[:PRESCREEN_PRIMARY_MEMBER_NAME] = nil
	# end

 end