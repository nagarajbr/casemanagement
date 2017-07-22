class ApplicationController < ActionController::Base


 protect_from_forgery with: :exception
  #check_authorization

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: "Invalid authenticity token", status: 403
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to needs_path, alert: "You do not have permission to perform this action."
  # end

  include GDS::SSO::ControllerMethods
  before_filter :set_cache_buster
   before_filter :authenticate_user!
  before_filter :require_signin_permission!
  helper_method  :current_user


  before_filter :session_expiry


  def session_expiry
    session[:EXPIRE_TIME] = 30.minutes.from_now if session[:EXPIRE_TIME].blank?
    session_time_left = session[:EXPIRE_TIME].to_datetime < Time.now.to_datetime ? -1 : 1
    if session_time_left < 0
      clear_session_variables()
      session[:EXPIRE_TIME] = nil
      redirect_to("#{GDS::SSO::Config.oauth_root_url}")
    else
      session[:EXPIRE_TIME] = 30.minutes.from_now
    end
  end



  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache,no-store"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


    def verify_authenticity_token
      raise ActionController::InvalidAuthenticityToken unless verified_request?
    end

    def redirect_to_back
        if request.env["HTTP_REFERER"].present?
          redirect_to :back
        else
          redirect_to client_search_path
        end
    end

    def navigate_back_to_called_page()
      #  Manoj Patil 09/19/2014
      #  Description - Reset the session and Navigate to called page after successful creation or update.
      # Example : for data correction user will navigate to Clien- profile page - after populating missing data elements - he should be redirected back to Application screening page.
      if session[:NAVIGATE_FROM].present?
        l_navigate_from = session[:NAVIGATE_FROM]
          session[:NAVIGATE_FROM] = nil
          redirect_to l_navigate_from
        end
    end

      def clear_session_variables()
        session[:CLIENT_ID] = nil
        session[:new_application_id] = nil
        session[:application_step] = nil
        session[:NAVIGATED_FROM] = nil
        session[:CALLED_FROM] = nil
        session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
        session[:NAVIGATE_TO] = nil
        session[:user_step] = nil
        session[:user_params] = nil
        session[:clicked_menu] = nil
        session[:NEW_CLIENT_SSN] = nil
        session[:APPLICATION_SCREENING_STEP] = nil
        session[:NEW_APPLICATION_SCREENING_ID] =  nil
        session[:PRIMARY_APPLICANT] = nil

        session[:PROGRAM_WIZARD_STEP] = nil
        session[:NEW_PROGRAM_WIZARD_ID] = nil
        session[:APPLICATION_ID] = nil
        session[:PROGRAM_UNIT_ID] = nil
        session[:PGU_SAME_AS_APP] = nil
        session[:NEW_PRE_SCREENING_ID] = nil
        session[:PRE_SCREENING_STEP] = nil
        # household_prescreening
        session[:HOUSEHOLD_PRE_SCREENING_ID] = nil
        session[:HOUSEHOLD_PRE_SCREENING_STEP] = nil
        session[:PRESCREEN_PRIMARY_MEMBER_NAME] = nil

        session[:ADD_CLIENT_FROM_CLIENT_APPLICATION] = nil
        session[:NAVIGATE_FROM] = nil
        session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = nil

      end

      def assessment_plan_not_required
        ActionPlanDetail.is_there_an_assessment_activity_created_for_the_client(session[:CLIENT_ID]) #|| ClientAssessment.there_is_no_complete_or_withdrawn_asessment_for_client(session[:CLIENT_ID])
      end

end

