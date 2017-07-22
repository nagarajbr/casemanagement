
#require 'resque/server'

Intake::Application.routes.draw do

  root :to => redirect("login/login")

# whats wrong with page comments
  resources :comments, :only => [:create]
  resources :service_programs, :except => [:destroy]
  resources :time_limits, :only => [:index]
  # resources :client_parental_rspabilities, :except => [:destroy]
  resources :client_relationships, :except => [:show, :edit, :update]
  resources :supl_retro_bns_payments
  resources :cost_centers
  resources :resource_uses
  resources :employers, :except => [:destroy]
  resources :cost_centers
   #Roots for codetables
  resources :code_tables, :except => [:destroy] do
    resources :codetable_items, :except => [:show, :destroy, :index]
  end
  #Rao 07/09/2014
  #Roots for system_params
  resources :system_param_categories, :except => [:destroy] do
    resources :system_params, :except => [:show, :destroy, :index]
  end





  # clients assessment custom routes -start
    # resources :assessment_barriers
  # Manoj -01/30/2015 - Assessment-recommendations start
  get "/assessment_recommendation/:assessment_id/show" => "assessment_barriers#show_assessment_recommendations", as: :show_assessment_recommendations


  # Manoj -01/30/2015 - Assessment-recommendations start
  patch "/client_assessments/:id/complete_assessment" => "client_assessments#complete_assessment", as: :complete_assessment
  get "/assessment_recommendation/:id/withdraw_assessment" => "client_assessments#withdraw_assessment", as: :withdraw_assessment
  post "/assessment_recommendation/:id/withdraw_assessment_save" => "client_assessments#withdraw_assessment_save", as: :withdraw_assessment_save
  #Start-Short Assessment routes
  get "/client_assessments/:client_id/selected_sections_for_short_assessment" => "client_assessments#selected_sections_for_short_assessment",as: :selected_sections_for_short_assessment
  post "/client_assessments/process_selected_sections_for_short_assessment" => "client_assessments#process_selected_sections_for_short_assessment",as: :process_selected_sections_for_short_assessment
  #End- Short Assessment routes
  get "/client_assessment_histories/index" => "client_assessment_histories#index" , as: :client_assessment_histories
  get "/client_assessment_histories/:id/show" => "client_assessment_histories#show" , as: :client_assessment_history_show
  # clients assessment custom routes -end



  #mount Resque::Server.new, at: "/resque"



     # Manoj 09/08/2014
  # client application wizard custom routes -start
  get "client_applications/:application_id/edit_wizard" => "client_applications#edit_wizard", as: :edit_application_wizard
  get "client_applications/new_member_search/:application_id/:called_from"  => "client_applications#new_member_search", as: :new_member_search
  get "client_applications/member_search_results"  => "client_applications#member_search_results", as: :member_search_results
  get "client_applications/:id/set_member_in_session" => "client_applications#set_member_in_session", as: :set_member_in_session
  get "client_applications/new_member"  => "client_applications#new_member", as: :new_member
  post "client_applications/new_member"  => "client_applications#create_new_member", as: :create_new_member
  get "client_applications/new_application_wizard_initialize" => "client_applications#new_application_wizard_initialize", as: :new_application_wizard_initialize
  delete "client_applications/:application_id/destroy_application_member/:id/:called_from" => "client_applications#destroy_application_member", as: :destroy_application_member

  get "client_applications/edit_application_member_multiple_relationship/:application_id/:called_from"  => "client_applications#edit_application_member_multiple_relationship", as: :edit_application_member_multiple_relationship
  put "client_applications/update_application_member_multiple_relationship"  => "client_applications#update_application_member_multiple_relationship", as: :update_application_member_multiple_relationship



  get "client_applications/edit_client_application_question_answers/:application_id"  => "client_applications#edit_client_application_question_answers", as: :edit_client_application_question_answers
  put "client_applications/update_client_application_question_answers/:application_id"  => "client_applications#update_client_application_question_answers", as: :update_client_application_question_answers



#  This should be below custom routes -
 # Index
  get "/applications" => "client_applications#index", as: :client_applications
  #client search
  get "/applications/client_search" => "client_applications#client_search", as: :client_applications_search
  # new
  get "/client_applications/new" => "client_applications#new", as: :new_client_application
  # create
  post "/client_applications" => "client_applications#create", as: :create_new_application
  # show action should be after new only.--don't change the order
   # show
  get "/client_applications/:application_id" => "client_applications#show", as: :client_application

 # application_member independent menu -start
get "application_member/:application_id" => "client_applications#menu_manage_application_member", as: :menu_manage_application_member
  # application_member independent menu -end
   # application_member independent menu -start
get "application_mber_relationship/:application_id" => "client_applications#menu_manage_application_member_relationship", as: :menu_manage_application_member_relationship
  # application_member independent menu -end
get "client_applications/complete_application/:application_id" => "client_applications#complete_application", as: :complete_application

  # client application wizard custom routes -end


 #  Manoj 09/18/2014
# Application Wizard screening custom routes - start

  get "application_screenings/start_check_program_eligibility_wizard/:application_id"  => "application_screenings#start_check_program_eligibility_wizard", as: :start_check_program_eligibility_wizard
  put "application_screenings/process_check_program_eligibility_wizard/:application_id"  => "application_screenings#process_check_program_eligibility_wizard", as: :process_check_program_eligibility_wizard
  get "application_screenings/application_check_program_eligibility_wizard_initialize/:application_id"  => "application_screenings#application_check_program_eligibility_wizard_initialize", as: :application_check_program_eligibility_wizard_initialize
  get "application_screenings/exit_wizard" => "application_screenings#exit_wizard", as: :exit_wizard
  get "application_screenings/new_verification_document/:application_id"  => "application_screenings#new_verification_document", as: :new_verification_document
  post "application_screenings/new_verification_document/:application_id"  => "application_screenings#create_verification_document", as: :create_verification_document
  delete 'application_screenings/delete_verification_document/:application_id/:document_id' => "application_screenings#delete_verification_document", as: :delete_verification_document
  get "application_screenings/view_screening_summary/:application_id" => "application_screenings#view_screening_summary", as: :view_screening_summary

  get "application_screenings/application_eligibility_correction_link/:id/:called_from"  => "application_screenings#application_eligibility_correction_link", as: :application_eligibility_correction_link

 # Application Wizard screening custom routes - end

 #  Application Screening Results

  get "application_eligibility_results" => "application_eligibility_results#index", as: :index_client_applications_for_screening_results
  get "application_eligibility_results/:application_id/show" => "application_eligibility_results#show", as: :show_application_screening_result

#  Program Unit Screening Results
  get "program_unit_eligibility_results" => "application_eligibility_results#index_client_program_unit_for_screening_results", as: :index_client_program_unit_for_screening_results
  get "program_unit_eligibility_results/:program_unit_id/show" => "application_eligibility_results#show_program_unit_screening_result", as: :show_program_unit_screening_result

  get "application_screenings/by_pass_application_screenings_wizard" => "application_screenings#by_pass_application_screenings_wizard", as: :by_pass_application_screenings_wizard






# Modal Client Search
get "/modal_client_search/new"  => "modal_client_search#new", as: :new_modal_client_search
get "/modal_client_search/search"  => "modal_client_search#search", as: :modal_client_search
get "/modal_client_search/:id/set_session" => "modal_client_search#set_client_in_modal_session", as: :set_client_in_modal_session


 #resources :clients
  get "/clients/demographics/edit" => "clients#edit", as: :edit_client
  put "/clients/demographics/edit" => "clients#update", as: :update_client
  get "/clients/demographics/show" => "clients#show", as: :show_client
  get "/clients/demographics/new"  => "clients#new", as: :new_client
  post "/clients/demographics/new"  => "clients#create", as: :create_client
  get "/clients/search"  => "clients#search", as: :client_search
  get "/client/:id/:household_id/set_session" => "clients#set_selected_client_in_session", as: :set_client_in_session
  get "/clients/search/new"  => "clients#new_search", as: :new_focus_client_search
  get "/client/search_results" => "clients#search_results", as: :search_results



  #resources :phones
  get "/clients/phones/edit" => "phones#edit", as: :edit_phone
  put "/clients/phones/edit" => "phones#update", as: :update_phone
  get "/clients/phones/show" => "phones#show", as: :show_phone
  get "/clients/phones/new"  => "phones#new", as: :new_phone
  post "/clients/phones/new"  => "phones#create", as: :create_phone



  get "/clients/addresses/show" => "addresses#show", as: :show_address
  get "/clients/addresses/edit" => "addresses#edit", as: :edit_address
  put "/clients/addresses/edit" => "addresses#update", as: :update_address
  get "/clients/addresses/new"  => "addresses#new", as: :new_address
  post "/clients/addresses/new"  => "addresses#create", as: :create_address

  get "/clients/addresses/:type/:id/fix_residence_address_information"  => "addresses#living_arrangement", as: :living_arrangement
  post "/clients/addresses/fix_residence_address_information"  => "addresses#update_living_arrangement", as: :update_living_arrangement


   #resources :aliens
   get "/clients/aliens/show" => "aliens#show", as: :show_alien
  get "/clients/aliens/edit" => "aliens#edit", as: :edit_alien
  put "/clients/aliens/edit" => "aliens#update", as: :update_alien
  get "/clients/aliens/new"  => "aliens#new", as: :new_alien
  post "/clients/aliens/new"  => "aliens#create", as: :create_alien


 # pregnancies
  get ":menu/clients/medical_pregnancy/show" => "pregnancies#show", as: :show_pregnancy
  get ":menu/clients/medical_pregnancy/edit/:id" => "pregnancies#edit", as: :edit_pregnancy
  put ":menu/clients/medical_pregnancy/edit/:id" => "pregnancies#update", as: :update_pregnancy
  get ":menu/clients/medical_pregnancy/new"  => "pregnancies#new", as: :new_pregnancy
  post ":menu/clients/medical_pregnancy/new_data"  => "pregnancies#create", as: :create_pregnancy
  delete ":menu/clients/medical_pregnancy/:id" => "pregnancies#destroy", as: :delete_pregnancy

#client_immunizations
   get ":menu/client_immunization/show" => "client_immunizations#show", as: :show_client_immunization
  get ":menu/client_immunization/edit" => "client_immunizations#edit", as: :edit_client_immunization
  put ":menu/client_immunization/edit" => "client_immunizations#update", as: :update_client_immunization
  get ":menu/client_immunization/new"  => "client_immunizations#new", as: :new_client_immunization
  post ":menu/client_immunization/new"  => "client_immunizations#create", as: :create_client_immunization
  delete ":menu/client_immunization/show" => "client_immunizations#destroy", as: :delete_client_immunization



  # resources :client_races Kiran 08/21/2014
  get "/clients/races/show" => "client_races#show", as: :show_race
  get "/clients/races/new" => "client_races#new", as: :new_race
  post "/clients/races/create" => "client_races#create", as: :create_race
  get "/clients/races/edit" => "client_races#new", as: :edit_race






  #Rao 07/24/2014
  #Roots for expenses

  resources :expenses do
    resources :expense_details
  end
  get "client_expenses/expense_summary" => "expenses#expense_summary", as: :expense_summary

  #Rao 07/24/2014

  get ":menu/educations" => "educations#index", as: :educations
  get ":menu/educations/new" => "educations#new", as: :new_education
  post ":menu/educations/new" => "educations#create", as: :create_education
  get ":menu/educations/:id" => "educations#show", as: :education
  get ":menu/educations/:id/edit" => "educations#edit", as: :edit_education
  put ":menu/educations/:id/edit" => "educations#update", as: :update_education
  delete ":menu/educations/:id" => "educations#destroy", as: :delete_education



  get ":menu/employments" => "employments#index", as: :employments
  get ":menu/employments/new" => "employments#new", as: :new_employment
  post ":menu/employments/new" => "employments#create", as: :create_employment
  get ":menu/employments/:employment_id" => "employments#show", as: :employment
  get ":menu/employments/:employment_id/edit" => "employments#edit", as: :edit_employment
  put ":menu/employments/:employment_id/edit" => "employments#update", as: :update_employment
  delete ":menu/employments/:employment_id" => "employments#destroy", as: :delete_employment
  get ":menu/employment/navigate_to_employer_creation_page" => "employments#navigate_to_employer_creation_page", as: :navigate_to_employer_creation_page


  get ":menu/employments/:employment_id/employment_details" => "employment_details#index", as: :employment_employment_details
  get ":menu/employments/:employment_id/employment_details/new" => "employment_details#new", as: :new_employment_employment_detail
  post ":menu/employments/:employment_id/employment_details/new" => "employment_details#create", as: :create_employment_employment_detail
  get ":menu/employments/:employment_id/employment_details/:employment_detail_id" => "employment_details#show", as: :employment_employment_detail
  get ":menu/employments/:employment_id/employment_details/:employment_detail_id/edit" => "employment_details#edit", as: :edit_employment_employment_detail
  put ":menu/employments/:employment_id/employment_details/:employment_detail_id/edit" => "employment_details#update", as: :update_employment_employment_detail
  delete ":menu/employments/:employment_id/employment_details/:employment_detail_id"   => "employment_details#destroy", as: :delete_employment_employment_detail


 # incomes controller will be used to capture unearned incomes -start


  # get ":menu/incomes/new" => "incomes#new", as: :new_income
  # post ":menu/incomes/new" => "incomes#create", as: :create_income
  # get ":menu/incomes" => "incomes#index", as: :incomes
  # get ":menu/incomes/:id" => "incomes#show", as: :income
  # get ":menu/incomes/:id/edit" => "incomes#edit", as: :edit_income
  # put ":menu/incomes/:id/edit" => "incomes#update", as: :update_income
  # delete ":menu/incomes/:id" => "incomes#destroy", as: :delete_income
  get "/incomes/income_summary" => "incomes#income_summary", as: :income_summary

  get ":menu/unearned_incomes/new" => "incomes#new", as: :new_unearned_income
  post ":menu/unearned_incomes/new" => "incomes#create", as: :create_unearned_income
  get ":menu/unearned_incomes" => "incomes#index", as: :unearned_incomes
  get ":menu/unearned_incomes/:id" => "incomes#show", as: :unearned_income
  get ":menu/unearned_incomes/:id/edit" => "incomes#edit", as: :edit_unearned_income
  put ":menu/unearned_incomes/:id/edit" => "incomes#update", as: :update_unearned_income
  delete ":menu/unearned_incomes/:id" => "incomes#destroy", as: :delete_unearned_income


  # get ":menu/incomes/:income_id/income_details" => "income_details#index", as: :income_income_details
  # get ":menu/incomes/:income_id/income_details/new" => "income_details#new", as: :new_income_income_detail
  # post ":menu/incomes/:income_id/income_details/new" => "income_details#create", as: :create_income_income_detail
  # get ":menu/incomes/:income_id/income_details/:id" => "income_details#show", as: :income_income_detail
  # get ":menu/incomes/:income_id/income_details/:id/edit" => "income_details#edit", as: :edit_income_income_detail
  # put ":menu/incomes/:income_id/income_details/:id/edit" => "income_details#update", as: :update_income_income_detail
  # delete ":menu/incomes/:income_id/income_details/:id"   => "income_details#destroy", as: :delete_income_income_detail

  get ":menu/unearned_incomes/:income_id/income_details" => "income_details#index", as: :unearned_income_income_details
  get ":menu/unearned_incomes/:income_id/income_details/new" => "income_details#new", as: :new_unearned_income_income_detail
  post ":menu/unearned_incomes/:income_id/income_details/new" => "income_details#create", as: :create_unearned_income_income_detail
  get ":menu/unearned_incomes/:income_id/income_details/:id" => "income_details#show", as: :unearned_income_income_detail
  get ":menu/unearned_incomes/:income_id/income_details/:id/edit" => "income_details#edit", as: :edit_unearned_income_income_detail
  put ":menu/unearned_incomes/:income_id/income_details/:id/edit" => "income_details#update", as: :update_unearned_income_income_detail
  delete ":menu/unearned_incomes/:income_id/income_details/:id"   => "income_details#destroy", as: :delete_unearned_income_income_detail


  # get ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons' =>  'income_detail_adjust_reasons#index', as: :income_detail_income_detail_adjust_reasons
  # post  ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons' => 'income_detail_adjust_reasons#create', as: :create_income_detail_income_detail_adjust_reason
  # get ':menu/incomesincomes/income_details/:income_detail_id/income_detail_adjust_reasons/new' => 'income_detail_adjust_reasons#new', as: :new_income_detail_income_detail_adjust_reason
  # get ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id/edit' => 'income_detail_adjust_reasons#edit', as: :edit_income_detail_income_detail_adjust_reason
  # get ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' =>  'income_detail_adjust_reasons#show', as: :income_detail_income_detail_adjust_reason
  # patch ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' =>  'income_detail_adjust_reasons#update', as: :update_income_detail_income_detail_adjust_reason
  # delete  ':menu/incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' => 'income_detail_adjust_reasons#destroy', as: :delete_income_detail_income_detail_adjust_reason

  get ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons' =>  'income_detail_adjust_reasons#index', as: :unearned_income_detail_income_detail_adjust_reasons
  post  ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons' => 'income_detail_adjust_reasons#create', as: :create_unearned_income_detail_income_detail_adjust_reason
  get ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/new' => 'income_detail_adjust_reasons#new', as: :new_unearned_income_detail_income_detail_adjust_reason
  get ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id/edit' => 'income_detail_adjust_reasons#edit', as: :edit_unearned_income_detail_income_detail_adjust_reason
  get ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' =>  'income_detail_adjust_reasons#show', as: :unearned_income_detail_income_detail_adjust_reason
  patch ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' =>  'income_detail_adjust_reasons#update', as: :update_unearned_income_detail_income_detail_adjust_reason
  delete  ':menu/unearned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:id' => 'income_detail_adjust_reasons#destroy', as: :delete_unearned_income_detail_income_detail_adjust_reason

  # Manoj 02/10/2015 - end

# incomes controller will be used to capture unearned incomes -end

# earned incomes start

  get ":menu/earned_incomes/new" => "household_member_incomes#new_household_member_income", as: :new_income
  post ":menu/earned_incomes/new" => "household_member_incomes#create_household_member_income", as: :create_income
  get ":menu/earned_incomes" => "household_member_incomes#index", as: :incomes
  get ":menu/earned_incomes/:income_id" => "household_member_incomes#show_household_member_income", as: :income
  get ":menu/earned_incomes/:income_id/edit" => "household_member_incomes#edit_household_member_income", as: :edit_income
  put ":menu/earned_incomes/:income_id/edit" => "household_member_incomes#update_household_member_income", as: :update_income
  delete ":menu/earned_incomes/:income_id" => "household_member_incomes#delete_household_member_income", as: :delete_income


# earned income_details -start
  get ":menu/earned_incomes/:income_id/income_details" => "household_member_income_details#household_member_income_detail_index", as: :income_income_details
  get ":menu/earned_incomes/:income_id/income_details/new" => "household_member_income_details#new_household_member_income_detail", as: :new_income_income_detail
  post ":menu/earned_incomes/:income_id/income_details/new" => "household_member_income_details#create_household_member_income_detail", as: :create_income_income_detail
  get ":menu/earned_incomes/:income_id/income_details/:income_detail_id" => "household_member_income_details#show_household_member_income_detail", as: :income_income_detail
  get ":menu/earned_incomes/:income_id/income_details/:income_detail_id/edit" => "household_member_income_details#edit_household_member_income_detail", as: :edit_income_income_detail
  put ":menu/earned_incomes/:income_id/income_details/:income_detail_id/edit" => "household_member_income_details#update_household_member_income_detail", as: :update_income_income_detail
  delete ":menu/earned_incomes/:income_id/income_details/:income_detail_id"   => "household_member_income_details#delete_household_member_income_detail", as: :delete_income_income_detail

# get "/household_registration/household_member_income_detail_index/:client_id/:income_id"  => "household_member_income_details#household_member_income_detail_index", as: :household_member_income_detail_index
# get "/household_registration/new_household_member_income_detail/:client_id/:income_id"  => "household_member_income_details#new_household_member_income_detail", as: :new_household_member_income_detail
# post "/household_registration/create_household_member_income_detail/:client_id/:income_id"  => "household_member_income_details#create_household_member_income_detail", as: :create_household_member_income_detail
# get "/household_registration/edit_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#edit_household_member_income_detail", as: :edit_household_member_income_detail
# put "/household_registration/update_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#update_household_member_income_detail", as: :update_household_member_income_detail
# delete "/household_registration/delete_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#delete_household_member_income_detail", as: :delete_household_member_income_detail
# get "/household_registration/show_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#show_household_member_income_detail", as: :show_household_member_income_detail
# hhmember_income_details -end

# incomedetail_adjustments -start

  get ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons' =>  'household_member_income_detail_adjustments#household_member_income_detail_adjustments_index', as: :income_detail_income_detail_adjust_reasons
  post  ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons' => 'household_member_income_detail_adjustments#create_household_member_income_detail_adjustment', as: :create_income_detail_income_detail_adjust_reason
  get ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/new' => 'household_member_income_detail_adjustments#new_household_member_income_detail_adjustment', as: :new_income_detail_income_detail_adjust_reason
  get ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:income_detail_adjustment_id/edit' => 'household_member_income_detail_adjustments#edit_household_member_income_detail_adjustment', as: :edit_income_detail_income_detail_adjust_reason
  get ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:income_detail_adjustment_id' =>  'household_member_income_detail_adjustments#show_household_member_income_detail_adjustment', as: :income_detail_income_detail_adjust_reason
  put ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:income_detail_adjustment_id' =>  'household_member_income_detail_adjustments#update_household_member_income_detail_adjustment', as: :update_income_detail_income_detail_adjust_reason
  delete  ':menu/earned_incomes/income_details/:income_detail_id/income_detail_adjust_reasons/:income_detail_adjustment_id' => 'household_member_income_detail_adjustments#delete_household_member_income_detail_adjustment', as: :delete_income_detail_income_detail_adjust_reason



# get "/household_registration/household_member_income_detail_adjustments_index/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#household_member_income_detail_adjustments_index", as: :household_member_income_detail_adjustments_index
# get "/household_registration/new_household_member_income_detail_adjustment/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#new_household_member_income_detail_adjustment", as: :new_household_member_income_detail_adjustment
# post "/household_registration/create_household_member_income_detail_adjustment/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#create_household_member_income_detail_adjustment", as: :create_household_member_income_detail_adjustment
# get "/household_registration/edit_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#edit_household_member_income_detail_adjustment", as: :edit_household_member_income_detail_adjustment
# put "/household_registration/update_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#update_household_member_income_detail_adjustment", as: :update_household_member_income_detail_adjustment
# delete "/household_registration/delete_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#delete_household_member_income_detail_adjustment", as: :delete_household_member_income_detail_adjustment
# get "/household_registration/show_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#show_household_member_income_detail_adjustment", as: :show_household_member_income_detail_adjustment





# earned incomes end


  #For Share feature in income, resources and expense
  get "/clients/:type/:type_id/share/new_share_search"  => "clients_share#new_share_search", as: :new_client_share_search
  get "/clients/:type/:type_id/share/search"  => "clients_share#share_search", as: :client_share_search
  get "/clients/:type/:type_id/share/search/:id"  => "clients_share#create_share", as: :create_share
  delete "/clients/:type/:type_id/share/search/:id"  => "clients_share#destroy", as: :delete_share
  get ":menu/incomes/:id" => "incomes#show", as: :show_shared_income
  get "/clients/share/resources/:id" => "resources#show", as: :show_shared_resource
  get "/clients/share/expenses/:id" => "expenses#show", as: :show_shared_expense


  #Kiran 07/24/2014
  #Roots for resources
  resources :resources do
    resources :resource_details
  end

get "/resources/resource_details/:resource_detail_id/index" => "resource_adjustments#index", as: :index_resource_adjustment
get "/resources/resource_details/:resource_detail_id/new" => "resource_adjustments#new", as: :new_resource_adjustment
post "/resources/resource_details/:resource_detail_id/create" => "resource_adjustments#create", as: :create_resource_adjustments
get "/resources/resource_details/:id/show" => "resource_adjustments#show", as: :show_resource_adjustment
get "/resources/resource_details/:id/edit" => "resource_adjustments#edit", as: :edit_resource_adjustment
patch "/resources/resource_details/:id/update" => "resource_adjustments#update", as: :update_resource_adjustments
delete "/resources/resource_details/:id/destroy" => "resource_adjustments#destroy", as: :destroy_resource_adjustments


get "/resources/resource_details/:resource_detail_id/resource_uses_index" => "resource_uses#index", as: :index_resource_uses
get "/resources/resource_details/:resource_detail_id/resource_use_new" => "resource_uses#new", as: :new_resource_uses
post "/resources/resource_details/:resource_detail_id/resource_use_create" => "resource_uses#create", as: :create_resource_uses
get "/resources/resource_details/:id/resource_use_show" => "resource_uses#show", as: :show_resource_uses
get "/resources/resource_details/:id/resource_use_edit" => "resource_uses#edit", as: :edit_resource_uses
patch "/resources/resource_details/:id/resource_uss_update" => "resource_uses#update", as: :update_resource_uses
delete "/resources/resource_details/:id/resource_use_destroy" => "resource_uses#destroy", as: :destroy_resource_uses


get "/summaryresources/resource_summary" => "resources#resource_summary", as: :resource_summary


  get ":menu/:characteristic_type/characteristics/index" => "client_characteristics#index", as: :index_client_characteristic
  get ":menu/:characteristic_type/characteristics/:id/show" => "client_characteristics#show", as: :show_client_characteristic
  get ":menu/:characteristic_type/characteristics/new" => "client_characteristics#new", as: :new_client_characteristic
  get ":menu/:characteristic_type/characteristics/:id/edit" => "client_characteristics#edit", as: :edit_client_characteristic
  patch ":menu/:characteristic_type/characteristics/:id/update" => "client_characteristics#update", as: :update_client_characteristic

  post ":menu/:characteristic_type/characteristics/create" => "client_characteristics#create", as: :create_client_characteristic
  delete ":menu/:characteristic_type/characteristics/:id/delete" => "client_characteristics#destroy", as: :delete_client_characteristic

  # Routes for Application Data Validation
  # get 'application/:application_id/data_validation' => "data_validation#validate", as: :run_application_data_validation

  get 'application/application_data_validation_correction_link/:application_id/:client_id/:validation_type/:navigate' => "data_validation#application_data_validation_correction_link", as: :application_data_validation_correction_link
  get 'application/data_validations' => "data_validation#index",as: :application_data_validations
  get 'application/data_validations/:application_id/validation_results' => "data_validation#validation_results", as: :application_data_validation_results
  # Program Unit Data verification Results
  get 'program_unit/program_unit_data_validation_index' => "data_validation#program_unit_data_validation_index",as: :program_unit_data_validation_index
  get 'program_unit/program_unit_data_validation_index/:program_unit_id/program_unit_data_validation_results' => "data_validation#program_unit_data_validation_results", as: :program_unit_data_validation_results
  get 'program_units/program_unit_data_validation_correction_link/:program_unit_id/:client_id/:validation_type/:navigate' => "data_validation#program_unit_data_validation_correction_link", as: :program_unit_data_validation_correction_link

  # get 'program_units/program_unit_client_income_correction_link/:program_unit_id/:client_id/:validation_type/:navigate' => "data_validation_static#program_unit_client_income_correction_link", as: :program_unit_client_income_correction_link
  # get 'program_unit/program_unit_data_validation_index/data_validation_screen' => "data_validation_static#data_validation_screen", as: :data_validation_screen
  # get 'program_unit/program_unit_data_validation_index/wage_ui_match' => "data_validation_static#wage_ui_match", as: :wage_ui_match
  # get 'program_unit/program_unit_data_validation_index/ocse_match' => "data_validation_static#ocse_match", as: :ocse_match

  # Routes for Overwriting Program Unit Members - begin
  get "/program_units/:program_unit_id/overwrite_program_unit_members/overwrite_wizard_initialize" => "program_units#overwrite_wizard_initialize", as: :overwrite_wizard_initialize
  get "/program_units/:program_unit_id/overwrite_program_unit_members/start_overwrite_wizard" => "program_units#start_overwrite_wizard", as: :start_overwrite_wizard
  post "/program_units/:program_unit_id/overwrite_program_unit_members" => "program_units#process_overwrite_wizard", as: :process_overwrite_wizard
  get "program_units/:program_unit_id/:from/edit_program_unit_members" => "program_units#edit_program_unit_members", as: :edit_program_unit_members
  post "program_units/:program_unit_id/:from/add_program_unit_member" => "program_units#add_program_unit_member", as: :add_program_unit_member
  delete "program_units/:program_unit_id/:from/delete_program_unit_member/:id/" => "program_units#destroy_program_unit_member_over_write_wizard", as: :delete_program_unit_member
  # Routes for Overwriting Program Unit Members - end

#  Routes for Application Document Verification
  # resources :client_doc_verfications
  get 'application/client_doc_verfications' => "client_doc_verfications#index", as: :client_doc_verfications
  get 'application/client_doc_verfications/:application_id/new' => "client_doc_verfications#new", as: :new_client_doc_verfication
  post 'application/client_doc_verfications/:application_id' => "client_doc_verfications#create", as: :create_client_doc_verfication
  get 'application/client_doc_verfications/:application_id/edit/:id' => "client_doc_verfications#edit", as: :edit_client_doc_verfication
  put 'application/client_doc_verfications/:application_id/:id' => "client_doc_verfications#update", as: :update_client_doc_verfication
  get 'application/client_doc_verfications/:application_id/index' => "client_doc_verfications#document_verification_index", as: :document_verification_index
  get 'application/client_doc_verfications/:application_id/show/:id' => "client_doc_verfications#show", as: :show_client_doc_verfication
  delete 'application/client_doc_verfications/:application_id/show/:id' => "client_doc_verfications#destroy", as: :delete_client_doc_verfication

 # Manage documents per Program Unit -start
  get 'program_unit/client_doc_verfications' => "client_doc_verfications#program_unit_document_verification_index", as: :program_unit_document_verification_index

  get 'program_unit/client_doc_verfications/:program_unit_id/new' => "client_doc_verfications#new_program_unit_member_document", as: :new_program_unit_member_document
  post 'program_unit/client_doc_verfications/:program_unit_id' => "client_doc_verfications#create_program_unit_member_document", as: :create_program_unit_member_document

  get 'program_unit/client_doc_verfications/:program_unit_id/edit/:id' => "client_doc_verfications#edit_program_unit_member_document", as: :edit_program_unit_member_document
  put 'program_unit/client_doc_verfications/:program_unit_id/:id' => "client_doc_verfications#update_program_unit_member_document", as: :update_program_unit_member_document

  get 'program_unit/client_doc_verfications/:program_unit_id/index' => "client_doc_verfications#show_program_unit_documents", as: :show_program_unit_documents
  get 'program_unit/client_doc_verfications/:program_unit_id/show/:id' => "client_doc_verfications#show_one_program_unit_document", as: :show_one_program_unit_document

  delete 'program_unit/client_doc_verfications/:program_unit_id/show/:id' => "client_doc_verfications#destroy_program_unit_document", as: :destroy_program_unit_document
  # Manage documents per Program Unit -end

  #  Manage document per focus client -start
  get 'focus_client/doc_verfications' => "client_doc_verfications#index_focus_client_documents", as: :index_focus_client_documents
  get 'focus_client/doc_verfications/show/:id' => "client_doc_verfications#show_focus_client_document", as: :show_focus_client_document

  get 'focus_client/doc_verfications/new' => "client_doc_verfications#new_focus_client_document", as: :new_focus_client_document
  post 'focus_client/doc_verfications/new' => "client_doc_verfications#create_focus_client_document", as: :create_focus_client_document

  get 'focus_client/doc_verfications/edit/:id' => "client_doc_verfications#edit_focus_client_document", as: :edit_focus_client_document
  put 'focus_client/doc_verfications/edit/:id' => "client_doc_verfications#update_focus_client_document", as: :update_focus_client_document


  delete 'focus_client/doc_verfications/destroy/:id' => "client_doc_verfications#destroy_focus_client_document", as: :destroy_focus_client_document

  #  Manage document per focus client -end




 # Manoj 09/08/2014
  # client application wizard custom routes

  get "/client_program_units" => "program_units#index", as: :program_units
  get "client_program_units/show/:program_unit_id" => "program_units#work_flow_status", as: :work_flow_status
  get "program_units/edit_program_unit_wizard_initialize/:program_unit_id" => "program_units#edit_program_unit_wizard_initialize", as: :edit_program_unit_wizard_initialize
  get "program_units/edit_program_unit_wizard/:program_unit_id" => "program_units#edit_program_unit_wizard", as: :edit_program_unit_wizard
  put "program_units/edit_program_unit_wizard/:program_unit_id"  => "program_units#update_program_unit_wizard", as: :update_program_unit_wizard

  get "program_units/program_unit_member_search/:program_unit_id"  => "program_units#program_unit_member_search", as: :program_unit_member_search
  get "program_units/program_unit_member_search_results/:program_unit_id"  => "program_units#program_unit_member_search_results", as: :program_unit_member_search_results
  get "program_units/set_program_unit_member_in_session/:program_unit_id/:id" => "program_units#set_program_unit_member_in_session", as: :set_program_unit_member_in_session

  delete "program_units/:program_unit_id/destroy_program_unit_member/:id/" => "program_units#destroy_program_unit_member", as: :destroy_program_unit_member
  get "program_units/new_program_unit_member/:program_unit_id"  => "program_units#new_program_unit_member", as: :new_program_unit_member
  post "program_units/new_program_unit_member/:program_unit_id"  => "program_units#create_program_unit_member", as: :create_program_unit_member

  get "program_units/edit_program_unit_member_multiple_relationship/:program_unit_id"  => "program_units#edit_program_unit_member_multiple_relationship", as: :edit_program_unit_member_multiple_relationship
  put "program_units/update_program_unit_member_multiple_relationship/:program_unit_id"  => "program_units#update_program_unit_member_multiple_relationship", as: :update_program_unit_member_multiple_relationship



  get "program_units/new_program_unit_verification_document/:program_unit_id"  => "program_units#new_program_unit_verification_document", as: :new_program_unit_verification_document
  post "program_units/new_program_unit_verification_document/:program_unit_id"  => "program_units#create_program_unit_verification_document", as: :create_program_unit_verification_document
  delete 'program_units/delete_program_unit_verification_document/:program_unit_id/:document_id' => "program_units#delete_program_unit_verification_document", as: :delete_program_unit_verification_document

  get "program_units/view_program_unit_summary/:program_unit_id" => "program_units#view_program_unit_summary", as: :view_program_unit_summary
# Manoj 04/21/2015 - start - Assign Case Manager button
  get "program_units/edit_assign_case_manager/:program_unit_id" => "program_units#edit_assign_case_manager", as: :edit_assign_case_manager
  put "program_units/edit_assign_case_manager/:program_unit_id" => "program_units#update_assign_case_manager", as: :update_assign_case_manager
# Manoj 04/21/2015 - end
# Manoj 06/09/2015 - start - Assign Eligibility worker button
  get "program_units/edit_assign_eligibility_worker/:program_unit_id" => "program_units#edit_assign_eligibility_worker", as: :edit_assign_eligibility_worker
  put "program_units/edit_assign_eligibility_worker/:program_unit_id" => "program_units#update_assign_eligibility_worker", as: :update_assign_eligibility_worker
# Manoj 04/21/2015 - end



  get "program_units/program_unit_screening_correction_link/:id/:program_unit_id/:called_from"  => "program_units#program_unit_screening_correction_link", as: :program_unit_screening_correction_link






  #  Program Unit

 # Program Unit Action custom route start
  get "/program_unit_actions/edit/:program_unit_id" => "program_unit_actions#edit", as: :edit_program_unit_action
  put "/program_unit_actions/update/:program_unit_id" => "program_unit_actions#update", as: :update_program_unit_action
  get "program_unit_actions/show/:program_unit_id" => "program_unit_actions#show", as: :show_program_unit_action
  get "program_unit_actions/initialize/:program_unit_id" => "program_unit_actions#program_unit_action_wizard_initialize", as: :program_unit_action_wizard_initialize
  get "program_unit_actions/cancel/:program_unit_id" => "program_unit_actions#cancel_pgu_action_wizard", as: :cancel_pgu_action_wizard

  # Program Unit Action custom route end



# Program Wizard - custom routes - start
# Program wizard - index-summary

  # Progran wizard
  get "/program_unit/program_wizards/program_unit_eligibility_wizard_initialize/:program_unit_id" => "program_wizards#program_unit_eligibility_wizard_initialize", as: :program_unit_eligibility_wizard_initialize
  get "/program_unit/program_wizards/start_eligibility_determination_wizard/:program_unit_id" => "program_wizards#start_eligibility_determination_wizard", as: :start_eligibility_determination_wizard
  put "/program_unit/program_wizards/start_eligibility_determination_wizard/:program_unit_id"  => "program_wizards#process_eligibility_determination_wizard", as: :process_eligibility_determination_wizard

  #  Cancel Program wizard.
  get "/program_unit/program_wizards/cancel_eligibility_determination_wizard/:program_unit_id/:program_wizard_id" => "program_wizards#cancel_eligibility_determination_wizard", as: :cancel_eligibility_determination_wizard


  # Approve Program Unit or Payment Unit creation process

  get "/program_unit/index_program_unit_run_ids/update_retain_indicator_for_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#update_retain_indicator_for_run_id", as: :update_retain_indicator_for_run_id
  get "/program_unit/program_unit_data_validation_index/index_program_unit_run_ids/show_program_wizard_run_id_details/:program_unit_id/:program_wizard_id" => "program_wizards#show_program_wizard_run_id_details", as: :show_program_wizard_run_id_details
  get "/program_unit/index_program_unit_run_ids/approve_program_wizard_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#approve_program_wizard_run_id", as: :approve_program_wizard_run_id
  get "/program_unit/index_program_unit_run_ids/submit_program_wizard_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#submit_program_wizard_run_id", as: :submit_program_wizard_run_id
# TEA DIVERSION -START
  get "/program_unit/index_program_unit_run_ids/new_submit_tea_diversion_payment_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#new_submit_tea_diversion_payment_run_id", as: :new_submit_tea_diversion_payment_run_id
  post "/program_unit/index_program_unit_run_ids/new_submit_tea_diversion_payment_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#create_submit_tea_diversion_payment_run_id", as: :create_submit_tea_diversion_payment_run_id

  get "/program_unit/index_program_unit_run_ids/edit_submit_tea_diversion_payment_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#edit_submit_tea_diversion_payment_run_id", as: :edit_submit_tea_diversion_payment_run_id
  put "/program_unit/index_program_unit_run_ids/edit_submit_tea_diversion_payment_run_id/:program_unit_id/:program_wizard_id" => "program_wizards#update_submit_tea_diversion_payment_run_id", as: :update_submit_tea_diversion_payment_run_id
# TEA DIVERSION - END

  #  Program unit Eligibility summary


  get "/program_unit/program_wizards/index_eligibility_determination_runs/:program_unit_id" => "program_wizards#index_eligibility_determination_runs", as: :index_eligibility_determination_runs




# Manoj 03/18/2015
  get "/program_unit/program_wizards/:program_wizard_id/add_benefit_member" => "program_wizards#new_benefit_member", as: :new_benefit_member
  post "/program_unit/program_wizards/:program_wizard_id/create_and_exit_benefit_member" => "program_wizards#create_benefit_member", as: :create_benefit_member
  delete "program_unit/program_wizards/:program_wizard_id/destroy_program_unit_benefit_member/:program_benefit_member_id" => "program_wizards#destroy_program_unit_benefit_member", as: :destroy_program_unit_benefit_member

  get "/no_cpp_warning/program_unit/program_wizards/:program_wizard_id/:client_id/" => "program_wizards#no_cpp_warning", as: :no_cpp_warning
  get "/no_assessment_warning/program_unit/program_wizards/:program_wizard_id/:client_id/" => "program_wizards#no_assessment_warning", as: :no_assessment_warning


  get "/program_unit/index_program_unit_run_ids/edit_rejection_of_program_unit/:program_unit_id/:program_wizard_id" => "program_wizards#edit_rejection_of_program_unit", as: :edit_rejection_of_program_unit
  put "/program_unit/index_program_unit_run_ids/update_rejection_of_program_unit/:program_unit_id/:program_wizard_id" => "program_wizards#update_rejection_of_program_unit", as: :update_rejection_of_program_unit

  get "/program_unit/index_program_unit_run_ids/ready_for_assessment/:program_unit_id/:program_wizard_id" => "program_wizards#ready_for_assessment", as: :ready_for_assessment
  get "/program_unit/index_program_unit_run_ids/continue_assessment/:program_unit_id/:program_wizard_id" => "program_wizards#continue_assessment", as: :continue_assessment
  get "/program_unit/index_program_unit_run_ids/select_this_run_for_planning/:program_unit_id/:program_wizard_id" => "program_wizards#select_this_run_for_planning", as: :select_this_run_for_planning

  get "/program_unit/program_wizards/by_pass_program_wizard" => "program_wizards#by_pass_program_wizard", as: :by_pass_program_wizard
# Program Wizard - custom routes - end


#under_construction_page
get "/page_under_construction" => "generic#under_construction", as: :under_construction_page



# WorkLoad Management
get "work_load_managements/supervisor_workspace" => "work_load_managements#supervisor_workspace", as: :work_load_managements_supervisor_workspace
get "work_load_managements/workload_queues" => "work_load_managements#workload_queues", as: :work_load_managements_workload_queues
get "work_load_managements/interviews_management" => "work_load_managements#interviews_management", as: :work_load_managements_interviews_management



  # Manoj Patil 10/18/2014
 # Pre screening Household custom routes -start
 get "prescreen_household/new_pre_screening_household_wizard_initialize" => "prescreen_households#pre_screening_household_wizard_initialize", as: :pre_screening_household_wizard_initialize
 get "/prescreen_household/new" => "prescreen_households#start_pre_screening_household_wizard", as: :start_pre_screening_household_wizard
 post "/prescreen_household/fetch" => "prescreen_households#populate_details_from_xml", as: :populate_details_from_xml
  # create
 post "/prescreen_household" => "prescreen_households#process_pre_screening_household_wizard", as: :process_pre_screening_household_wizard
 get "/prescreen_household" => "prescreen_households#show", as: :show_pre_screening_household
 get "/prescreen_household/thankyou/:household_prescreening_id" => "prescreen_households#prescreen_household_thankyou", as: :prescreen_household_thankyou
 # put "/prescreen_household/thankyou/:household_prescreening_id" => "prescreen_households#update_prescreen_household_thankyou", as: :update_prescreen_household_thankyou
 get "/prescreen_household/cancel_wizard" => "prescreen_households#cancel_wizard", as: :prescreen_household_cancel_wizard

 # add prescreen_household_member in wizard
  get "prescreen_household/:prescreen_household_id/new_prescreen_household_member"  => "prescreen_households#new_prescreen_household_member", as: :new_prescreen_household_member
  post "prescreen_household/:prescreen_household_id/new_prescreen_household_member"  => "prescreen_households#create_prescreen_household_member", as: :create_new_prescreen_household_member
  delete "prescreen_household/:prescreen_household_id/destroy_prescreen_hh_member/:id" => "prescreen_households#destroy_prescreen_household_member", as: :destroy_prescreen_household_member

  get "prescreen_household/edit_prescreen_household_question_answers/:household_prescreening_id"  => "prescreen_households#edit_prescreen_common_assessment", as: :edit_prescreen_common_assessment
  put "prescreen_household/update_prescreen_household_question_answers/:household_prescreening_id"  => "prescreen_households#update_prescreen_common_assessment", as: :update_prescreen_common_assessment


get "/prescreen_household/capture_ssn/:household_prescreening_id" => "prescreen_households#edit_prescreen_capture_ssn", as: :edit_prescreen_capture_ssn
put "/prescreen_household/capture_ssn/:household_prescreening_id" => "prescreen_households#update_prescreen_capture_ssn", as: :update_prescreen_capture_ssn

 # Pre screening Household custom routes -end

  get "/out_of_state_payments" => "out_of_state_payments#index",as: :out_of_state_payments
  get "/out_of_state_payments/edit" => "out_of_state_payments#edit", as: :edit_out_of_state_payment
  post "/out_of_state_payments" => "out_of_state_payments#create", as: :create_out_of_state_payment
 delete "/out_of_state_payments/:id/destroy" => "out_of_state_payments#destroy", as: :destroy_out_of_state_payment


   get "/in_state_payments" => "in_state_payments#index",as: :in_state_payments
  get "/in_state_payments/:id/edit" => "in_state_payments#edit", as: :edit_in_state_payments
  patch "/in_state_payments/:id/edit" => "in_state_payments#update", as: :update_in_state_payments
 get "/in_state_payments/:id/show" => "in_state_payments#show", as: :show_in_state_payments

 get "/programunit_instate" => "in_state_payments#program_unit_instatepayments",as: :program_unit_in_state_payments
 get "/programunit_instate/:id/show" => "in_state_payments#program_unit_instatepayments_show",as: :program_unit_in_state_payments_show
 get "/programunit_instate/:id/edit" => "in_state_payments#program_unit_instatepayments_edit",as: :program_unit_in_state_payments_edit
 patch "/programunit_instate/:id/edit" => "in_state_payments#program_unit_instatepayments_update",as: :program_unit_in_state_payments_update

  # Intake Queues custome routes start
  # resources :potential_intake_clients
  get "/potential_intake_clients" => "potential_intake_clients#index", as: :intake_queue
  get "/potential_intake_clients/:id" => "potential_intake_clients#process_for_intake", as: :process_for_intake
  get "/potential_intake_clients_select_client/:client_id" => "potential_intake_clients#set_client_in_session_and_navigate", as: :set_client_in_session_and_navigate
  get "/potential_intake_mark_as_complete/:id" => "potential_intake_clients#mark_as_complete", as: :mark_as_complete




  # Intake Queues custome routes end


  resources :sanctions do
   resources :sanction_details
  end

# resources :providers
#provider custom route start
  get "/providers/index" => "providers#index", as: :provider_index
  get "/providers/:provider_id/edit" => "providers#edit", as: :edit_provider
  patch "/providers/:provider_id/edit" => "providers#update", as: :update_provider
  get "/providers/:provider_id/show" => "providers#show", as: :show_provider
  get "/providers/new"  => "providers#new", as: :new_provider
  post "/providers/new"  => "providers#create", as: :create_provider
  get "/providers/:head_provider_id/new_branch_office"  => "providers#new_branch_office", as: :new_branch_office
  post "/providers/:head_provider_id/new_branch_office"  => "providers#create_branch_office", as: :create_branch_office
  get "/providers/:head_provider_id/branch_offices_index" => "providers#branch_offices_index", as: :branch_offices_index
  get "/providers/:branch_office_id/edit_branch_office" => "providers#edit_branch_office", as: :edit_branch_office
  patch "/providers/:branch_office_id/edit_branch_office" => "providers#update_branch_office", as: :update_branch_office

  #provider custom route end

#provider search custorm route start
 get "/searchprovider/new"  => "providers#provider_new_search", as: :new_provider_search
 get "/searchprovider"  => "providers#search", as: :provider_search
 get "/search_provider"  => "providers#search_payments_provider", as: :search_payments_provider
 get "/provider/:id/set_session" => "providers#set_selected_provider_in_session", as: :set_provider_in_session
 get "/search_provider/new"  => "providers#payments_provider_new_search", as: :payments_provider_new_search
 # get "/search_payments_provider"  => "providers#payments_provider_search", as: :payments_provider_search

#provider search custorm route end

 #provider address start
 get "/provideraddress" => "provider_addresses#show", as: :show_provider_address
 get "/provideraddress/new" => "provider_addresses#new", as: :new_provider_address
 post "/provideraddress/create" => "provider_addresses#create", as: :create_provider_address
 get "/provideraddress/edit" => "provider_addresses#edit", as: :edit_provider_address
 put "/provideraddress/update" => "provider_addresses#update", as: :update_provider_address
 #provider address end


 #provider_languages start

get "/provider_languages/index"  => "provider_languages#index", as: :provider_languages
get "/provider_languages/new"  => "provider_languages#new", as: :new_provider_language
post "/provider_languages/:provider_id"  => "provider_languages#create"
get "/provider_languages/:id" => "provider_languages#show", as: :show_provider_language
delete "/provider_languages/:id/destroy" => "provider_languages#destroy",as: :destroy_provider_language
get "/provider_languages/:id/edit" => "provider_languages#edit", as: :edit_provider_language
patch "/provider_languages/:id/update" => "provider_languages#update", as: :update_provider_language
get "/provider_languages/:provider_id/new"  => "provider_languages#new", as: :provider_languages_new
#provider_languages end


#provider_service start
get "/provider_services/index"  => "provider_services#provider_service_index", as: :provider_services
get "/provider_services/new"  => "provider_services#provider_service_new", as: :new_provider_service
post "/provider_services/create"  => "provider_services#provider_service_create"
get "/provider_services/:id/show" => "provider_services#provider_service_show", as: :show_provider_service
get "/provider_services/:id/edit" => "provider_services#provider_service_edit", as: :edit_provider_service
patch "/provider_services/:id/update" => "provider_services#provider_service_update", as: :update_provider_service
#provider_service end


#provider_service_area start
get "/provider_services/provider_service_area/:service_id/index"  => "provider_services#provider_service_area_index", as: :provider_service_areas
get "/provider_services/provider_service_area/:service_id/new"  => "provider_services#provider_service_area_new", as: :new_provider_service_area
post "/provider_services/provider_service_area/:service_id/create"  => "provider_services#provider_service_area_create", as: :provider_service_area_create

delete "/provider_services/provider_service_area/:id/destroy" => "provider_services#provider_service_area_destroy",as: :destroy_provider_service_area


#provider_service_area end

#provider_service_area_availability start
get "/provider_services/provider_service_area_availability/:service_area_id/index"  => "provider_services#provider_service_area_availability_index", as: :provider_service_areas_availability
get "/provider_services/provider_service_area_availability/:service_area_id/new"  => "provider_services#provider_service_area_availability_new", as: :new_provider_service_area_availability
post "/provider_services/provider_service_area_availability/:service_area_id/create"  => "provider_services#provider_service_area_availability_create", as: :create_provider_service_area_availability
get "/provider_services/provider_service_area_availability/:id/show" => "provider_services#provider_service_area_availability_show", as: :show_provider_service_area_availability
delete "/provider_services/provider_service_area_availability/:id/destroy" => "provider_services#provider_service_area_availability_destroy",as: :provider_service_area_availability_destroy
get "/provider_services/provider_service_area_availability/:id/edit" => "provider_services#provider_service_area_availability_edit", as: :edit_provider_service_area_availability
patch "/provider_services/provider_service_area_availability/:id/update" => "provider_services#provider_service_area_availability_update", as: :update_provider_service_area_availability


#provider_service_area_availability end


# PROVIDER SERVICE AGREEMENT -START

get "/provider_agreements" => "provider_agreements#index", as: :provider_agreements
get "/provider_agreements/:id/show" => "provider_agreements#show", as: :provider_agreements_show
get "/provider_agreements/:id/edit_provider_agreement_wizard" => "provider_agreements#edit_provider_agreement_wizard", as: :edit_provider_agreement_wizard
get "provider_agreements/provider_agreement_wizard_initialize" => "provider_agreements#provider_agreement_wizard_initialize", as: :provider_agreement_wizard_initialize
get "/provider_agreements/new" => "provider_agreements#start_provider_agreement_wizard", as: :start_provider_agreement_wizard
post "/provider_agreements" => "provider_agreements#process_provider_agreement_wizard", as: :process_provider_agreement_wizard

get "/provider_agreements/:id/approve_provider_agreement" => "provider_agreements#approve_provider_agreement", as: :approve_provider_agreement
get "/provider_agreements/:id/provider_agreement_termination_edit" => "provider_agreements#provider_agreement_termination_edit", as: :provider_agreement_termination_edit
patch "/provider_agreements/:id/provider_agreement_termination_date_reason_update" => "provider_agreements#provider_agreement_termination_date_reason_update", as: :provider_agreement_termination_date_reason_update
get "/provider_agreements/:id/provider_agreement_print" => "provider_agreements#provider_agreement_print", as: :provider_agreement_print

# # Manoj 05/07/2015 - Work Flow start
get "/provider_agreements/:id/request_for_approval" => "provider_agreements#request_for_approval", as: :provider_agreement_request_for_approval
get "/provider_agreements/:id/provider_agreement_reject_edit" => "provider_agreements#provider_agreement_reject_edit", as: :provider_agreement_reject_edit
patch "/provider_agreements/:id/provider_agreement_reject_update" => "provider_agreements#provider_agreement_reject_update", as: :provider_agreement_reject_update
# Manoj 05/07/2015 - Work Flow end

# PROVIDER SERVICE AGREEMENT -END

# client service_authorization custom routes -start
  get "/service_mamagement/select_program_unit" => "service_authorizations#srvc_management_select_program_unit", as: :srvc_management_select_program_unit
 # Index
  # get "/service_authorization/:program_unit_id/index" => "service_authorizations#service_authorizations_index", as: :service_authorizations_index
  # get "/supportive_service/:action_plan_id/action_plan_details/:action_plan_detail_id/service_authorizations/index" => "service_authorizations#service_authorizations_index", as: :service_authorizations_index
  # get "/supportive_service/:action_plan_id/action_plan_details/:action_plan_detail_id/service_authorizations/:program_unit_id/index" => "service_authorizations#service_authorizations_index", as: :service_authorizations_index
  get "/supportive_service/service_authorizations/:program_unit_id/index" => "service_authorizations#service_authorizations_index", as: :service_authorizations_index
# Initialize
  get "/supportive_service/service_authorization/new_service_authorization_wizard_initialize" => "service_authorizations#new_service_authorization_wizard_initialize", as: :new_service_authorization_wizard_initialize
  # new
  get "/supportive_service/service_authorization/start_service_authorization_wizard" => "service_authorizations#start_service_authorization", as: :start_service_authorization
  # create
  post "/supportive_service/service_authorization/start_service_authorization_wizard" => "service_authorizations#process_service_authorization", as: :process_service_authorization
  # Edit
  get "/supportive_service/service_authorization/:service_authorization_id/edit_wizard" => "service_authorizations#edit_service_authorization_wizard", as: :edit_service_authorization_wizard

  get "/supportive_service/service_authorization/new_schedule"  => "service_authorizations#new_service_authorization_schedule", as: :new_service_authorization_schedule
  post "/supportive_service/service_authorization/new_schedule"  => "service_authorizations#create_service_authorization_schedule", as: :create_service_authorization_schedule
  delete "/supportive_service/service_authorization/delete_service_authorization_schedule/:id" => "service_authorizations#destroy_service_schedule", as: :destroy_service_schedule


  get "/supportive_service/service_authorization/show_service_authorization/:service_authorization_id" => "service_authorizations#show_service_authorization", as: :show_service_authorization
  get "/supportive_service/service_authorization/delete_service_authorization/:service_authorization_id" => "service_authorizations#destroy_service_authorization", as: :destroy_service_authorization
  get "/supportive_service/service_authorization/authorize_service_authorization/:service_authorization_id" => "service_authorizations#authorize_service_authorization", as: :authorize_service_authorization



  get "/supportive_service/non_transport_supportive_service/new"  => "service_authorizations#non_transportation_srvc_new", as: :non_transportation_srvc_new
  post "/supportive_service/non_transport_supportive_service/new"  => "service_authorizations#non_transportation_srvc_create", as: :non_transportation_srvc_create

  get "/supportive_service/check_ts_or_nts_supportive_service"  => "service_authorizations#check_ts_or_nts_supportive_service", as: :check_ts_or_nts_supportive_service
  post "/supportive_service/check_ts_or_nts_supportive_service"  => "service_authorizations#check_ts_or_nts_supportive_service_post", as: :check_ts_or_nts_supportive_service_post

  get "/supportive_service/ts_non_ts_supportive_service/show/:service_authorization_id"  => "service_authorizations#check_ts_or_nts_ss_show", as: :check_ts_or_nts_ss_show
  get "/supportive_service/non_transport_supportive_service/show/:service_authorization_id"  => "service_authorizations#non_transportation_srvc_show", as: :non_transportation_srvc_show
  get "/supportive_service/non_transport_supportive_service/edit/:service_authorization_id" => "service_authorizations#non_transportation_srvc_edit", as: :non_transportation_srvc_edit
  put "/supportive_service/non_transport_supportive_service/edit/:service_authorization_id" => "service_authorizations#non_transportation_srvc_update", as: :non_transportation_srvc_update
  delete "/supportive_service/ts_non_ts_supportive_service/delete/:service_authorization_id" => "service_authorizations#non_transportation_srvc_delete", as: :non_transportation_srvc_delete
  get "/supportive_service/non_transport_supportive_service/authorize_non_transport_service_authorization/:service_authorization_id"  => "service_authorizations#authorize_non_transport_service_authorization", as: :authorize_non_transport_service_authorization

  # service approval Index
  get "/service_approval/:program_unit_id/service_approval_index" => "service_authorizations#service_approval_index", as: :service_approval_index
  get "/service_approval/:service_authorization_id/service_approval_show" => "service_authorizations#service_approval_show", as: :service_approval_show
  get "/service_approval/:service_authorization_id/service_approval_approve" => "service_authorizations#service_approval_approve", as: :service_approval_approve




  # client service_authorization custom routes -end


#ServiceAuthorizationLineItemsController - custom routes - start

# Common routes for Transportation and Non Transportation Service Payment Line Items
get "/authorized_service_line_items/provider_authorised_services_index" => "service_authorization_line_items#provider_service_authorizations_index", as: :provider_service_authorizations_index
get "/authorized_service_line_items/:service_authorization_id/srvc_authorization_line_items_index" => "service_authorization_line_items#service_authorization_line_items_index", as: :service_authorization_line_items_index
get "/authorized_service_line_items/:service_authorization_id/:service_authorization_line_item_id/srvc_authorization_line_item_show" => "service_authorization_line_items#service_authorization_line_item_show", as: :service_authorization_line_item_show
get "/authorized_service_line_items/:service_authorization_id/service_payment_request_for_approval" => "service_authorization_line_items#service_payment_request_for_approval", as: :service_payment_request_for_approval

# Transport service line items
get "/authorized_service_line_items/:service_authorization_id/:service_authorization_line_item_id/transport_service_authorization_line_item_edit" => "service_authorization_line_items#transport_service_authorization_line_item_edit", as: :transport_service_authorization_line_item_edit
put "/authorized_service_line_items/:service_authorization_id/:service_authorization_line_item_id/transport_service_authorization_line_item_edit" => "service_authorization_line_items#transport_service_authorization_line_item_update", as: :transport_service_authorization_line_item_update

# Non Transport service line items

get "/authorized_service_line_items/:service_authorization_id/:service_authorization_line_item_id/non_transport_service_authorization_line_item_edit" => "service_authorization_line_items#non_transport_service_authorization_line_item_edit", as: :non_transport_service_authorization_line_item_edit
put "/authorized_service_line_items/:service_authorization_id/:service_authorization_line_item_id/non_transport_service_authorization_line_item_edit" => "service_authorization_line_items#non_transport_service_service_authorization_line_item_update", as: :non_transport_service_service_authorization_line_item_update
get "/authorized_service_line_items/:service_authorization_id/non_transport_service_payment_record_new" => "service_authorization_line_items#non_transport_service_payment_record_new", as: :non_transport_service_payment_record_new
post "/authorized_service_line_items/:service_authorization_id/non_transport_service_payment_record_new" => "service_authorization_line_items#non_transport_service_payment_record_create", as: :non_transport_service_payment_record_create

#ServiceAuthorizationLineItemsController - custom routes - end


resources :work_tasks, :except => [:destroy]
# Manoj 04/21/2015 - work_on_task link to navigate to different pages - where task can be completed.
get "/work_tasks/work_on_task/:work_task_id" => "work_tasks#work_on_task",as: :work_on_task
get "/search_work_tasks/search_criteria" => "work_tasks#work_task_search",as: :work_task_search
get "/search_work_tasks/search_results" => "work_tasks#work_task_search_results",as: :work_task_search_results
get "/my_program_units" => "work_tasks#my_program_units",as: :my_program_units
get "/my_applications" => "work_tasks#my_applications",as: :my_applications
get "set_session_variables/:type/selected_case/:id" => "work_tasks#selected_case",as: :selected_case
#case Transfer
get "/my_program_units/:program_unit_id/case_transfer_new"  => "work_tasks#case_transfer_new", as: :case_transfer_new
post "/my_program_units/:program_unit_id/case_transfer_create"  => "work_tasks#case_transfer_create", as: :case_transfer_create



# get "/employers/index" => "employers#index", as: :employers_index

#employer search custorm route start
 get "/searchemployer/new"  => "employers#employer_new_search", as: :employer_new_search
 get "/searchemployer"  => "employers#search", as: :employer_search
 get "/employer/:id/set_session" => "employers#set_selected_employer_in_session", as: :set_selected_employer_in_session
#employer search custorm route end

#employer address start
 get "/employeraddress" => "employer_addresses#show", as: :show_employer_address
 get "/employeraddress/new" => "employer_addresses#new", as: :new_employer_address
 post "/employeraddress/create" => "employer_addresses#create", as: :create_employer_address
 get "/employeraddress/edit" => "employer_addresses#edit", as: :edit_employer_address
 put "/employeraddress/update" => "employer_addresses#update", as: :update_employer_address
 #employer address end

 #employer contacts start
 get "/employercontact" => "employer_contacts#show", as: :show_employer_contact
 get "/employercontact/new" => "employer_contacts#new", as: :new_employer_contact
 post "/employercontact/create" => "employer_contacts#create", as: :create_employer_contact
 get "/employercontact/edit" => "employer_contacts#edit", as: :edit_employer_contact
 put "/employercontact/update" => "employer_contacts#update", as: :update_employer_contact
 #employer contacts end

 #provider contacts start
 get "/providercontact" => "provider_contacts#show", as: :show_provider_contact
 get "/providercontact/new" => "provider_contacts#new", as: :new_provider_contact
 post "/providercontact/create" => "provider_contacts#create", as: :create_provider_contact
 get "/providercontact/edit" => "provider_contacts#edit", as: :edit_provider_contact
 put "/providercontact/update" => "provider_contacts#update", as: :update_provider_contact
 #provider contacts end



# Provider - invoice custom routes - start
  get "/provider_invoices/index" => "provider_invoices#provider_invoice_index", as: :provider_invoice_index
  get "/provider_invoices/:provider_invoice_id/show" => "provider_invoices#provider_invoice_show", as: :provider_invoice_show
  get "/provider_invoices/:provider_invoice_id/provider_invoice_edit" => "provider_invoices#provider_invoice_edit", as: :provider_invoice_edit
  put "/provider_invoices/:provider_invoice_id/provider_invoice_edit" => "provider_invoices#provider_invoice_update", as: :provider_invoice_update
  get "/provider_invoices/:provider_invoice_id/provider_invoice_authorize" => "provider_invoices#provider_invoice_authorize", as: :provider_invoice_authorize
  get "/provider_invoices/:provider_invoice_id/provider_invoice_line_items_index" => "provider_invoices#provider_invoice_line_items_index", as: :provider_invoice_line_items_index
  get "/provider_invoices/:provider_invoice_id/:invoice_line_item_id/provider_invoice_line_item_show" => "provider_invoices#provider_invoice_line_item_show", as: :provider_invoice_line_item_show
  get "/provider_invoices/:provider_invoice_id/edit_provider_invoice_reject" => "provider_invoices#edit_provider_invoice_reject", as: :edit_provider_invoice_reject
  put "/provider_invoices/:provider_invoice_id/edit_provider_invoice_reject" => "provider_invoices#update_provider_invoice_reject", as: :update_provider_invoice_reject


# Provider - invoice custom routes - end






#program_unit_representatives routes - start
  get "program_unit_representatives/:id/index" => "program_unit_representatives#index", as: :program_unit_representatives_index
  get "program_unit_representatives/:id/show" => "program_unit_representatives#show", as: :program_unit_representatives_show
  get "program_unit_representatives/new" => "program_unit_representatives#new", as: :program_unit_representatives_new
  post "program_unit_representatives/create" => "program_unit_representatives#create", as: :program_unit_representatives_create
  get "program_unit_representatives/:id/edit" => "program_unit_representatives#edit", as: :program_unit_representatives_edit
  patch "program_unit_representatives/:id/update" => "program_unit_representatives#update", as: :program_unit_representatives_update
  delete "/program_unit_representatives/:id/destroy" => "program_unit_representatives#destroy",as: :program_unit_representatives_destroy
  get "/program_unit_representatives/:id/deactivate" => "program_unit_representatives#program_unit_representative_deactivated", as: :program_unit_representative_deactivated
#Provider unit representatives routes - end




# ACTION PLAN / ACTION PLAN DETAILS / ACTIVITY HOURS - START
resources :action_plans do
  resources :action_plan_details
end
# ACTION_PLANS -START
get "/select_program_unit_id" => "action_plans#select_program_unit_id", as: :select_program_unit_id
get "/set_program_unit_id/:program_unit_id" => "action_plans#set_program_unit_id", as: :set_program_unit_id

get "/barriers/action_plans" => "action_plans#barriers_index", as: :barrier_action_plans
get "/action_plans/:id/close" => "action_plans#outcome_new", as: :outcome_new
post "/action_plans/:id/close" => "action_plans#outcome_create", as: :outcome_create
#employment plan comments - start
post "/action_plans/:action_plan_type/create_comments_for_employment_plan" => "action_plans#create_comments_for_employment_plan", as: :create_comments_for_employment_plan
#employment plan comments - end

# ACTION_PLANS -END

# ACTION PLAN DETAILS START
get "/action_plans/:action_plan_id/action_plan_details/:action_plan_detail_id/authorize_service" => "action_plan_details#authorize_service", as: :authorize_service
# Routes for Action Plan Details, Action, Service and Supportive Services start - Kiran 01/29/2015
get "/action_plans/:action_plan_id/action_plan_details/service/new" => "action_plan_details#new_service", as: :new_service_action_plan_detail
get "/action_plans/:action_plan_id/action_plan_details/supportive_service/:id/new" => "action_plan_details#new_supportive_service", as: :new_supportive_service_action_plan_detail
get "/action_plans/:action_plan_id/action_plan_details/service/:id" => "action_plan_details#edit_service_action_plan_detail", as: :edit_service_action_plan_detail
get "/action_plans/:action_plan_id/action_plan_details/supportive_service/:id" => "action_plan_details#edit_supportive_service_action_plan_detail", as: :edit_supportive_service_action_plan_detail
get "/action_plans/:action_plan_id/action_plan_details/:id/supportive_services/:ss_id/show" => "action_plan_details#show_supportive_service", as: :show_supportive_service
get "/action_plans/:action_plan_id/start_action_plan_detail_wizard" => "action_plan_details#start_action_plan_detail_wizard", as: :start_action_plan_detail_wizard
get "/action_plans/:action_plan_id/action_plan_details/:id/edit_action_plan_detail_wizard" => "action_plan_details#edit_action_plan_detail_wizard", as: :edit_action_plan_detail_wizard
get "/action_plans/:action_plan_id/action_plan_details/:id/edit_activity" => "action_plan_details#edit_activity", as: :edit_activity
post "/action_plans/:action_plan_id/action_plan_details/:activity_type/:id/edit_activity" => "action_plan_details#update_activity", as: :update_activity
get "/action_plans/:action_plan_id/action_plan_detail_wizard_initialize" => "action_plan_details#action_plan_detail_wizard_initialize", as: :action_plan_detail_wizard_initialize
post "/action_plans/:action_plan_id/action_plan_detail" => "action_plan_details#process_action_plan_detail_wizard", as: :process_action_plan_detail_wizard
get "/action_plans/:action_plan_id/action_plan_details/:id/close" => "action_plan_details#close_action_plan_detail", as: :close_action_plan_detail
post "/action_plans/:action_plan_id/action_plan_details/:id/close" => "action_plan_details#create_apd_outcome", as: :create_apd_outcome
get "/action_plans/:action_plan_id/action_plan_details/:id/extend" => "action_plan_details#extend_action_plan_detail", as: :extend_action_plan_detail
post "/action_plans/:action_plan_id/action_plan_details/:id/extend" => "action_plan_details#create_apd_extension", as: :create_apd_extension

get "/client_activities/activity_hours" => "action_plan_details#client_activities", as: :client_activities
get "/client_activities/activity_hours/:id/show" => "action_plan_details#show_client_activity", as: :show_client_activity

get "clients/assessment/activity"  => "action_plan_details#assessment_activity", as: :assessment_activity
post "clients/assessment/activity"  => "action_plan_details#create_assessment_activity", as: :create_assessment_activity

get "/action_plans/:action_plan_id/action_plan_details/:activity_type/new"  => "action_plan_details#new_activity", as: :new_activity
post "/action_plans/:action_plan_id/action_plan_details/:activity_type/new"  => "action_plan_details#create_activity", as: :create_activity

# Routes for Action Plan Details, Action, Service and Supportive Services end

# ACTION PLAN DETAILS END


# ACTION PLAN / ACTION PLAN DETAILS / ACTIVITY HOURS - END









# activity_hours
get "/client_activities/:action_plan_id/:action_plan_detail_id/activity_hours" => "activity_hours#index", as: :action_plan_action_plan_detail_activity_hours
get "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/new" => "activity_hours#new", as: :enter_participation_hours
post "/client_activities/:action_plan_id/:action_plan_detail_id/activity_hours" => "activity_hours#create", as: :create_new_participation_hours

get "/action_plans/:action_plan_id/action_plan_details/:action_plan_detail_id/activity_hours/add_week" => "activity_hours#add_week", as: :activity_hours_add_week_info
get "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/index" => "activity_hours#activity_index", as: :activity_index
get "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/edit_week_info/:week_id" => "activity_hours#edit_week_info", as: :edit_week_info
post "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/edit_week_info/:week_id" => "activity_hours#save_week_info", as: :save_week_info
get "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/edit_week_activity/:week_id" => "activity_hours#edit_week_activity", as: :edit_week_activity
post "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/edit_week_activity/:week_id" => "activity_hours#save_week_activity", as: :save_week_activity
get "/client_activities/:action_plan_id/activity_hours/:action_plan_detail_id/:id" => "activity_hours#show", as: :show_participation_hours






# Manoj 01/24/2014 - common assessment - controller routes start
# 1.Assessment - Education-  English -start
# get "/:sub_section_id/assessment_show/:assessment_id/show" => "client_assessment_answers#show_common_assessment", as: :show_common_assessment
get "/:sub_section_id/assessment_new/:assessment_id/new_common_assessment" => "client_assessment_answers#new_common_assessment", as: :new_common_assessment
post "/:sub_section_id/assessment_new/:assessment_id/new_common_assessment" => "client_assessment_answers#create_common_assessment", as: :create_common_assessment
get "/:sub_section_id/assessment_edit/:assessment_id/edit_common_assessment" => "client_assessment_answers#edit_common_assessment", as: :edit_common_assessment
put "/:sub_section_id/assessment_update/:assessment_id/edit_common_assessment" => "client_assessment_answers#update_common_assessment", as: :update_common_assessment
get "client_assessment_answers/process_previous_step" => "client_assessment_answers#process_previous_step", as: :process_previous_step
get "client_assessment_answers/process_next_step" => "client_assessment_answers#process_next_step", as: :process_next_step

  # resources :client_assessment_employment_job_histories do
  #   resources :client_assessment_employment_job_history_details
  # end

# Manoj 01/24/2014 - common assessment - controller routes - end







  # Manoj -02/18/2015 - CPP - start
  get "/career_pathway_plan/index" => "career_pathway_plans#index", as: :index_cpp
  get "/career_pathway_plan/show/:cpp_id" => "career_pathway_plans#show", as: :show_cpp
  get "/career_pathway_plan/show_pending_cpp/:cpp_id" => "career_pathway_plans#show_pending_cpp", as: :show_pending_cpp
  get "/career_pathway_plan/manage_cpp" => "career_pathway_plans#manage_cpp", as: :manage_cpp
  get "/career_pathway_plan/:cpp_id/edit_cpp" => "career_pathway_plans#manage_cpp", as: :edit_cpp
  post "/career_pathway_plan/save_cpp" => "career_pathway_plans#save_cpp", as: :save_cpp
  get "/career_pathway_plan/:cpp_id/request_for_approval" => "career_pathway_plans#request_for_approval", as: :cpp_request_for_approval
  get "/career_pathway_plan/:cpp_id/edit_cpp_reject" => "career_pathway_plans#edit_cpp_reject", as: :edit_cpp_reject
  put "/career_pathway_plan/:cpp_id/update_cpp_reject" => "career_pathway_plans#update_cpp_reject", as: :update_cpp_reject
  get "/career_pathway_plan/:cpp_id/approve_cpp" => "career_pathway_plans#approve_cpp", as: :approve_cpp
  post "/career_pathway_plan/create_comments_for_career_pathway_plan" => "career_pathway_plans#create_comments_for_career_pathway_plan", as: :create_comments_for_career_pathway_plan
  # Manoj -02/18/2015 - CPP - end


  #get "/user_session/timeout" => "user_sessions#timeout"



   get "/schools/index" => "schools#index", as: :school_index
  get "/schools/:id/edit" => "schools#edit", as: :edit_school
  patch "/schools/:id/edit" => "schools#update", as: :update_school
  get "/schools/:id/show" => "schools#show", as: :show_school
  get "/schools/new"  => "schools#new", as: :new_school
  post "/schools/new"  => "schools#create", as: :create_school
  delete  "/schools/:id"  => "schools#destroy", as: :delete_school

   # resources :schools
  #schools search custorm route start

 get "/searchschools/search"  => "schools#search", as: :schools_search
 get "/schools/:id/set_session" => "schools#set_selected_schools_in_session", as: :set_selected_schools_in_session
#schoolssearch custorm route end

#schools address start
 get "/schooladdress/show" => "schools_addresses#show", as: :show_schools_address
 get "/schooladdress/new" => "schools_addresses#new", as: :new_schools_address
 post "/schooladdress/create" => "schools_addresses#create", as: :create_schools_address
 get "/schooladdress/edit" => "schools_addresses#edit", as: :edit_schools_address
 put "/schooladdress/update" => "schools_addresses#update", as: :update_schools_address
 #schools address end

 #schools contacts start
 get "/schoolcontact/show" => "schools_contacts#show", as: :show_schools_contact
 get "/schoolcontact/new" => "schools_contacts#new", as: :new_schools_contact
 post "/schoolcontact/create" => "schools_contacts#create", as: :create_schools_contact
 get "/schoolcontact/edit" => "schools_contacts#edit", as: :edit_schools_contact
 put "/schoolcontact/update" => "schools_contacts#update", as: :update_schools_contact
 #schools contacts end


  resources :alerts, :only => [:index]
  get "/alerts/:alert_id/acknowledge" => "alerts#acknowledge", as: :alerts_acknowledge
  get "/systemalerts/index" => "system_alerts#index", as: :system_alerts_index
  get "/systemalerts/:alert_id/edit" => "system_alerts#edit", as: :system_alerts_edit
  put "/systemalerts/:alert_id/edit" => "system_alerts#update", as: :system_alerts_update
  get "/systemalerts/:alert_id/show" => "system_alerts#show", as: :system_alerts_show
  get "/systemalerts/new"  => "system_alerts#new", as: :system_alerts_new
  post "/systemalerts/new"  => "system_alerts#create", as: :system_alerts_create
  delete "/systemalerts/:id" => "system_alerts#destroy", as: :system_alerts_delete


    # resources :client_scores
 get ":menu/client_scores" => "client_scores#index", as: :client_scores_index
  get ":menu/client_scores/:id/edit" => "client_scores#edit", as: :client_scores_edit
  put ":menu/client_scores/:id/edit" => "client_scores#update", as: :client_scores_update
  get ":menu/client_scores/:id/show" => "client_scores#show", as: :client_scores_show
  get ":menu/client_scores/new"  => "client_scores#new", as: :client_scores_new
  post ":menu/client_scores/new"  => "client_scores#create", as: :client_scores_create
  delete ":menu/client_scores/:id" => "client_scores#destroy", as: :client_scores_delete
# Service payments
  get "/payment_line_items" => "payment_line_items#index", as: :payment_line_items
  get "/payment_line_items/:id/show" => "payment_line_items#show", as: :payment_line_items_show



  get "/narative/index" => "narative#index", as: :narative
  post "/narative/create" => "narative#create", as: :narative_create
  get "/narative/:id/edit" => "narative#edit", as: :narative_edit
  put "/narative/:id/update" => "narative#update", as: :narative_update
  get "/narative/:entity_type/:entity_id/:long_description/show" => "narative#show", as: :narative_show



  # work_queue_local_office_subscriptions # Manoj Patil 09/01/2015 - start
  get "/work_queue_local_office_subscriptions/index" => "work_queue_local_office_subscriptions#index", as: :work_queue_local_office_subscriptions_index

  get "/work_queue_local_office_subscriptions/new" => "work_queue_local_office_subscriptions#new", as: :new_work_queue_local_office_subscription
  post "/work_queue_local_office_subscriptions/create" => "work_queue_local_office_subscriptions#create", as: :create_work_queue_local_office_subscription

  get "/work_queue_local_office_subscriptions/:local_office_id/edit" => "work_queue_local_office_subscriptions#edit", as: :edit_work_queue_local_office_subscription
  put "/work_queue_local_office_subscriptions/:local_office_id/update" => "work_queue_local_office_subscriptions#update", as: :update_work_queue_local_office_subscription

  delete "/work_queue_local_office_subscriptions/:local_office_id/delete" => "work_queue_local_office_subscriptions#destroy", as: :delete_work_queue_local_office_subscription
  # work_queue_local_office_subscriptions # Manoj Patil 09/01/2015 - end

    # work_queue_user_subscriptions # Manoj Patil 09/03/2015 - start
  get "/work_queue_user_subscriptions/index" => "work_queue_user_subscriptions#index", as: :work_queue_user_subscriptions_index
  get "/work_queue_user_subscriptions/user_queue_subscription_wizard_initialize" => "work_queue_user_subscriptions#user_queue_subscription_wizard_initialize", as: :user_queue_subscription_wizard_initialize
  get "/work_queue_user_subscriptions/new" => "work_queue_user_subscriptions#start_user_queue_subscription_wizard", as: :start_user_queue_subscription_wizard
  post "/work_queue_user_subscriptions" => "work_queue_user_subscriptions#process_user_queue_subscription_wizard", as: :process_user_queue_subscription_wizard
  get "/work_queue_user_subscriptions/:user_id/:local_office_id/edit" => "work_queue_user_subscriptions#edit", as: :edit_work_queue_user_subscription
  put "/work_queue_user_subscriptions/:user_id/:local_office_id/update" => "work_queue_user_subscriptions#update", as: :update_work_queue_user_subscription
  delete "/work_queue_user_subscriptions/:user_id/:local_office_id/delete" => "work_queue_user_subscriptions#destroy", as: :delete_work_queue_user_subscription
  # work_queue_user_subscriptions # Manoj Patil 09/03/2015 - end


# work_queue # Manoj Patil 09/14/2015 - start

  get "/my_queues/summary" => "work_queues#my_queue_summary", as: :my_queues_summary
  get "/my_queues/selected_queue_details_edit/:queue_type/:local_office_id" => "work_queues#selected_queue_details_edit", as: :selected_queue_details_edit
  put "/my_queues/selected_queue_details_update/:queue_type/:local_office_id" => "work_queues#selected_queue_details_update", as: :selected_queue_details_update
  get "/my_queues/assign_to_me/:queue_type/:local_office_id/:id" => "work_queues#assign_record_from_queue_to_me", as: :assign_record_from_queue_to_me

# work_queue # Manoj Patil 09/14/2015 - end

# user_local_offices - start
get "/user_local_offices/index" => "user_local_offices#index", as: :user_local_offices_index
get "/user_local_offices/new_initialize" => "user_local_offices#new_initialize", as: :user_local_offices_new_initialize

get "/user_local_offices/new" => "user_local_offices#new", as: :user_local_offices_new
post "/user_local_offices/new" => "user_local_offices#create", as: :user_local_offices_create
delete "/user_local_offices/:id/delete" => "user_local_offices#destroy", as: :user_local_offices_destroy

# user_local_offices - end


# Manoj = 11/3/2015
# Intake Management - Household Registration start
get "/household_registration/index" => "households#index", as: :household_index
get "/household_summary/index" => "household_registration_summary#index", as: :household_summary
get "/household_summary/navigate_to_selected_step/:step_id" => "household_registration_summary#navigate_to_selected_step", as: :navigate_to_selected_step
get "/household_member/registration_status" => "household_registration_summary#household_member_registration_status", as: :household_member_registration_status

# get "/household_registration/complete_household_registration/:household_id" => "households#complete_household_registration", as: :complete_household_registration
# get "/household_registration/exit_household_wizard/:household_member_id/:current_step" => "households#exit_household_wizard", as: :exit_household_wizard

# search -start
# household_id = 0 means HOH/
get "/household_registration/new_household_member_search/:household_id"  => "households#new_household_member_search", as: :new_household_member_search
get "/household_registration/household_member_search_results"  => "households#household_member_search_results", as: :household_member_search_results
# get "/household_registration/:id/set_household_member_in_session" => "households#set_household_member_in_session", as: :set_household_member_in_session
get "/household_registration/:id/:household_id/add_searched_client_into_current_household" => "households#add_searched_client_into_current_household", as: :add_searched_client_into_current_household
# search -end
# hhmember_demographics -start
get "/household_registration/new_household_member/:household_id"  => "households#new_household_member", as: :new_household_member
post "/household_registration/new_household_member/:household_id"  => "households#create_new_household_member", as: :create_new_household_member
get "/household_registration/edit_household_member/:client_id" => "households#edit_household_member", as: :edit_household_member
put "/household_registration/edit_household_member/:client_id" => "households#update_household_member", as: :update_household_member

# hhmember_demographics -end



# wizard start
get "/household_registration/new_household_wizard_initialize" => "households#new_household_wizard_initialize", as: :new_household_wizard_initialize
get "/household_registration/start_household_member_registration_wizard" => "households#start_household_member_registration_wizard", as: :start_household_member_registration_wizard
post "/household_registration/start_household_member_registration_wizard" => "households#process_household_member_registration_wizard", as: :process_household_member_registration_wizard
get "/household_registration/edit_household_wizard_initialize/:client_id" => "households#edit_household_wizard_initialize", as: :edit_household_wizard_initialize
get "/household_registration/navigate_to_first_skiped_step/:client_id" => "households#navigate_to_first_skiped_step", as: :navigate_to_first_skiped_step
get "/household_registration/:step/bread_crumbs_selected" => "households#bread_crumbs_selected", as: :bread_crumbs_selected

# wizard end

# hhmember-citizenship start

get "/household_registration/new_household_member_citizenship/:client_id/:menu"  => "aliens#new", as: :new_household_member_citizenship
post "/household_registration/create_household_member_citizenship/:client_id/:menu"  => "aliens#create", as: :create_household_member_citizenship
get "/household_registration/edit_household_member_citizenship/:client_id/:menu" => "aliens#edit", as: :edit_household_member_citizenship
put "/household_registration/update_household_member_citizenship/:client_id/:menu" => "aliens#update", as: :update_household_member_citizenship

# hhmember citizenship end



# hhmember address start

get "/household_registration/new_household_member_address" => "contacts#new", as: :new_household_member_address
post "/household_registration/create_household_member_address" => "contacts#create", as: :create_household_member_address
get "/household_registration/edit_household_member_address/:client_id"  => "contacts#new", as: :edit_household_member_address
post "/household_registration/update_household_member_address"  => "contacts#create", as: :update_household_member_address
post "household_registration/validate_address"  => "contacts#validate_address", as: :household_member_validate_address

# hhmember address end

# add client to selected household Address - start
get "/household_registration/add_client_to_selected_household_address/:client_id/:household_id/:address_id" => "households#add_client_to_selected_household_address", as: :add_client_to_selected_household_address
get "/household_registration/create_new_household_after_address_search/:client_id" => "households#create_new_household_after_address_search", as: :create_new_household_after_address_search

# add client to selected household Address - end


# hhmember education start
get "/household_registration/new_household_member_education/:client_id/:menu"  => "educations#new", as: :new_household_member_education
post "/household_registration/create_household_member_education/:client_id/:menu"  => "educations#create", as: :create_household_member_education
get "/household_registration/edit_household_member_education/:client_id/:education_id/:menu" => "educations#edit", as: :edit_household_member_education
put "/household_registration/update_household_member_education/:client_id/:education_id/:menu" => "educations#update", as: :update_household_member_education
delete "/household_registration/delete_household_member_education/:client_id/:education_id/:menu" => "educations#destroy", as: :delete_household_member_education
get "/household_registration/show_household_member_education/:client_id/:education_id/:menu" => "educations#show", as: :show_household_member_education
# hhmember education end



get "household_registration/edit_household_member_multiple_relationship/:household_id"  => "households#edit_household_member_multiple_relationship", as: :edit_household_member_multiple_relationship
put "household_registration/update_household_member_multiple_relationship/:household_id"  => "households#update_household_member_multiple_relationship", as: :update_household_member_multiple_relationship


# income/income  start
get "/household_registration/new_household_member_income/:client_id"  => "household_member_incomes#new_household_member_income", as: :new_household_member_income
post "/household_registration/create_household_member_income/:client_id"  => "household_member_incomes#create_household_member_income", as: :create_household_member_income
get "/household_registration/edit_household_member_income/:client_id/:income_id" => "household_member_incomes#edit_household_member_income", as: :edit_household_member_income
put "/household_registration/update_household_member_income/:client_id/:income_id" => "household_member_incomes#update_household_member_income", as: :update_household_member_income
delete "/household_registration/delete_household_member_income/:client_id/:income_id" => "household_member_incomes#delete_household_member_income", as: :delete_household_member_income
get "/household_registration/show_household_member_income/:client_id/:income_id" => "household_member_incomes#show_household_member_income", as: :show_household_member_income

# hhmember  assessment - start
get "/household_registration/edit_member_employment_assessment/:client_id/:assessment_id/:sub_section_id" => "households#edit_member_employment_assessment", as: :edit_member_employment_assessment
put "/household_registration/update_member_employment_assessment/:client_id/:assessment_id/:sub_section_id" => "households#update_member_employment_assessment", as: :update_member_employment_assessment

# hhmember  assessment - end



# hhmember_income_details -start
get "/household_registration/household_member_income_detail_index/:client_id/:income_id"  => "household_member_income_details#household_member_income_detail_index", as: :household_member_income_detail_index
get "/household_registration/new_household_member_income_detail/:client_id/:income_id"  => "household_member_income_details#new_household_member_income_detail", as: :new_household_member_income_detail
post "/household_registration/create_household_member_income_detail/:client_id/:income_id"  => "household_member_income_details#create_household_member_income_detail", as: :create_household_member_income_detail
get "/household_registration/edit_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#edit_household_member_income_detail", as: :edit_household_member_income_detail
put "/household_registration/update_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#update_household_member_income_detail", as: :update_household_member_income_detail
delete "/household_registration/delete_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#delete_household_member_income_detail", as: :delete_household_member_income_detail
get "/household_registration/show_household_member_income_detail/:client_id/:income_id/:income_detail_id" => "household_member_income_details#show_household_member_income_detail", as: :show_household_member_income_detail
# hhmember_income_details -end

# hhmember-incomedetail_adjustments -start
get "/household_registration/household_member_income_detail_adjustments_index/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#household_member_income_detail_adjustments_index", as: :household_member_income_detail_adjustments_index
get "/household_registration/new_household_member_income_detail_adjustment/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#new_household_member_income_detail_adjustment", as: :new_household_member_income_detail_adjustment
post "/household_registration/create_household_member_income_detail_adjustment/:client_id/:income_detail_id"  => "household_member_income_detail_adjustments#create_household_member_income_detail_adjustment", as: :create_household_member_income_detail_adjustment
get "/household_registration/edit_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#edit_household_member_income_detail_adjustment", as: :edit_household_member_income_detail_adjustment
put "/household_registration/update_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#update_household_member_income_detail_adjustment", as: :update_household_member_income_detail_adjustment
delete "/household_registration/delete_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#delete_household_member_income_detail_adjustment", as: :delete_household_member_income_detail_adjustment
get "/household_registration/show_household_member_income_detail_adjustment/:client_id/:income_detail_id/:income_detail_adjustment_id" => "household_member_income_detail_adjustments#show_household_member_income_detail_adjustment", as: :show_household_member_income_detail_adjustment
# hhmember-incomedetail_adjustments -end
# income/income details end

# hhmember- employment & employment detail start
# hhmember- employment start

get "/household_registration/new_household_member_employment/:client_id/:menu"  => "employments#new", as: :new_household_member_employment
post "/household_registration/create_household_member_employment/:client_id/:menu"  => "employments#create", as: :create_household_member_employment
get "/household_registration/edit_household_member_employment/:client_id/:employment_id/:menu" => "employments#edit", as: :edit_household_member_employment
put "/household_registration/update_household_member_employment/:client_id/:employment_id/:menu" => "employments#update", as: :update_household_member_employment
delete "/household_registration/delete_household_member_employment/:household_member_id/:employment_id/:menu" => "employments#destroy", as: :delete_household_member_employment
get "/household_registration/show_household_member_employment/:client_id/:employment_id/:menu" => "employments#show", as: :show_household_member_employment

# hhmember- employment end

# hhmember employment details start

get "/household_registration/household_member_employment_detail_index/:client_id/:employment_id/:menu"  => "employment_details#index", as: :household_member_employment_detail_index
get "/household_registration/new_household_member_employment_detail/:client_id/:employment_id/:menu"  => "employment_details#new", as: :new_household_member_employment_detail
post "/household_registration/create_household_member_employment_detail/:client_id/:employment_id/:menu"  => "employment_details#create", as: :create_household_member_employment_detail
get "/household_registration/edit_household_member_employment_detail/:client_id/:employment_id/:employment_detail_id/:menu" => "employment_details#edit", as: :edit_household_member_employment_detail
put "/household_registration/update_household_member_employment_detail/:client_id/:employment_id/:employment_detail_id/:menu" => "employment_details#update", as: :update_household_member_employment_detail
delete "/household_registration/delete_household_member_employment_detail/:client_id/:employment_id/:employment_detail_id/:menu" => "employment_details#destroy", as: :delete_household_member_employment_detail
get "/household_registration/show_household_member_employment_detail/:client_id/:employment_id/:employment_detail_id/:menu" => "employment_details#show", as: :show_household_member_employment_detail

# hhmember employment details end

# hhmember- employment & employment detail end

# hhmember- expense  start
get "/household_registration/new_household_member_expense/:client_id/:menu"  => "expenses#new", as: :new_household_member_expense
post "/household_registration/create_household_member_expense/:client_id/:menu"  => "expenses#create", as: :create_household_member_expense

get "/household_registration/show_household_member_expense/:client_id/:expense_id/:menu" => "expenses#show", as: :show_household_member_expense
get "/household_registration/edit_household_member_expense/:client_id/:expense_id/:menu" => "expenses#edit", as: :edit_household_member_expense
put "/household_registration/update_household_member_expense/:client_id/:expense_id/:menu" => "expenses#update", as: :update_household_member_expense
delete "/household_registration/delete_household_member_expense/:client_id/:expense_id/:menu" => "expenses#destroy", as: :delete_household_member_expense
# hhmember- expense end

#  hhmember- expense detail start

get "/household_registration/household_member_expense_detail_index/:client_id/:expense_id/:menu"  => "expense_details#index", as: :household_member_expense_detail_index
get "/household_registration/new_household_member_expense_detail/:client_id/:expense_id/:menu"  => "expense_details#new", as: :new_household_member_expense_detail
post "/household_registration/create_household_member_expense_detail/:client_id/:expense_id/:menu"  => "expense_details#create", as: :create_household_member_expense_detail
get "/household_registration/edit_household_member_expense_detail/:client_id/:expense_id/:expense_detail_id/:menu" => "expense_details#edit", as: :edit_household_member_expense_detail
put "/household_registration/update_household_member_expense_detail/:client_id/:expense_id/:expense_detail_id/:menu" => "expense_details#update", as: :update_household_member_expense_detail
delete "/household_registration/delete_household_member_expense_detail/:client_id/:expense_id/:expense_detail_id/:menu" => "expense_details#destroy", as: :delete_household_member_expense_detail
get "/household_registration/show_household_member_expense_detail/:client_id/:expense_id/:expense_detail_id/:menu" => "expense_details#show", as: :show_household_member_expense_detail
#  hhmember-expense detail end

#

# hhmember resources start
get "/household_registration/new_household_member_resource/:client_id/:menu"  => "resources#new", as: :new_household_member_resource
post "/household_registration/create_household_member_resource/:client_id/:menu"  => "resources#create", as: :create_household_member_resource
get "/household_registration/show_household_member_resource/:client_id/:resource_id/:menu" => "resources#show", as: :show_household_member_resource
get "/household_registration/edit_household_member_resource/:client_id/:resource_id/:menu" => "resources#edit", as: :edit_household_member_resource
put "/household_registration/update_household_member_resource/:client_id/:resource_id/:menu" => "resources#update", as: :update_household_member_resource
delete "/household_registration/delete_household_member_resource/:client_id/:resource_id/:menu" => "resources#destroy", as: :delete_household_member_resource

# hhmember resources end

#  hhmember resource details start
get "/household_registration/household_member_resource_detail_index/:client_id/:resource_id/:menu"  => "resource_details#index", as: :household_member_resource_detail_index
get "/household_registration/new_household_member_resource_detail/:client_id/:resource_id/:menu"  => "resource_details#new", as: :new_household_member_resource_detail
post "/household_registration/create_household_member_resource_detail/:client_id/:resource_id/:menu"  => "resource_details#create", as: :create_household_member_resource_detail
get "/household_registration/edit_household_member_resource_detail/:client_id/:resource_id/:resource_detail_id/:menu" => "resource_details#edit", as: :edit_household_member_resource_detail
put "/household_registration/update_household_member_resource_detail/:client_id/:resource_id/:resource_detail_id/:menu" => "resource_details#update", as: :update_household_member_resource_detail
delete "/household_registration/delete_household_member_resource_detail/:client_id/:resource_id/:resource_detail_id/:menu" => "resource_details#destroy", as: :delete_household_member_resource_detail
get "/household_registration/show_household_member_resource_detail/:client_id/:resource_id/:resource_detail_id/:menu" => "resource_details#show", as: :show_household_member_resource_detail


#  hhmember resource details end

#  hhmember resource detail adjustment start
get "/household_registration/household_member_resource_detail_adjustments_index/:client_id/:resource_detail_id/:menu" => "resource_adjustments#index", as: :household_member_resource_detail_adjustments_index
get "/household_registration/new_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:menu"  => "resource_adjustments#new", as: :new_household_member_resource_detail_adjustment
post "/household_registration/create_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:menu"  => "resource_adjustments#create", as: :create_household_member_resource_detail_adjustment
get "/household_registration/edit_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:resource_detail_adjustment_id/:menu" => "resource_adjustments#edit", as: :edit_household_member_resource_detail_adjustment
put "/household_registration/update_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:resource_detail_adjustment_id/:menu" => "resource_adjustments#update", as: :update_household_member_resource_detail_adjustment
delete "/household_registration/delete_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:resource_detail_adjustment_id/:menu" => "resource_adjustments#destroy", as: :delete_household_member_resource_detail_adjustment
get "/household_registration/show_household_member_resource_detail_adjustment/:client_id/:resource_detail_id/:resource_detail_adjustment_id/:menu" => "resource_adjustments#show", as: :show_household_member_resource_detail_adjustment

#  hhmember resource detail adjustment end

# hhmember resource uses start
get "/household_registration/household_member_resource_detail_uses_index/:client_id/:resource_detail_id/:menu" => "resource_uses#index", as: :household_member_resource_detail_uses_index
get "/household_registration/new_household_member_resource_detail_usage/:client_id/:resource_detail_id/:menu"  => "resource_uses#new", as: :new_household_member_resource_detail_usage
post "/household_registration/create_household_member_resource_detail_usage/:client_id/:resource_detail_id/:menu"  => "resource_uses#create", as: :create_household_member_resource_detail_usage
get "/household_registration/edit_household_member_resource_detail_usage/:client_id/:resource_detail_id/:resource_detail_use_id/:menu" => "resource_uses#edit", as: :edit_household_member_resource_detail_usage
put "/household_registration/update_household_member_resource_detail_usage/:client_id/:resource_detail_id/:resource_detail_use_id/:menu" => "resource_uses#update", as: :update_household_member_resource_detail_usage
delete "/household_registration/delete_household_member_resource_detail_usage/:client_id/:resource_detail_id/:resource_detail_use_id/:menu" => "resource_uses#destroy", as: :delete_household_member_resource_detail_usage
get "/household_registration/show_household_member_resource_detail_usage/:client_id/:resource_detail_id/:resource_detail_use_id/:menu" => "resource_uses#show", as: :show_household_member_resource_detail_usage


# hhmember resource uses end




# hh member unearned income & income details & adjustments  step start
# unearned income -start
get "/household_registration/new_household_member_unearned_income/:client_id/:menu"  => "incomes#new", as: :new_household_member_unearned_income
post "/household_registration/create_household_member_unearned_income/:client_id/:menu"  => "incomes#create", as: :create_household_member_unearned_income
get "/household_registration/show_household_member_unearned_income/:client_id/:id/:menu" => "incomes#show", as: :show_household_member_unearned_income
get "/household_registration/edit_household_member_unearned_income/:client_id/:id/:menu" => "incomes#edit", as: :edit_household_member_unearned_income
put "/household_registration/update_household_member_unearned_income/:client_id/:id/:menu" => "incomes#update", as: :update_household_member_unearned_income
delete "/household_registration/delete_household_member_unearned_income/:client_id/:id/:menu" => "incomes#destroy", as: :delete_household_member_unearned_income
# unearned income -end
# unearned income details start
get "/household_registration/household_member_unearned_income_detail_index/:client_id/:income_id/:menu"  => "income_details#index", as: :household_member_unearned_income_detail_index
get "/household_registration/new_household_member_unearned_income_detail/:client_id/:income_id/:menu"  => "income_details#new", as: :new_household_member_unearned_income_detail
post "/household_registration/create_household_member_unearned_income_detail/:client_id/:income_id/:menu"  => "income_details#create", as: :create_household_member_unearned_income_detail
get "/household_registration/show_household_member_unearned_income_detail/:client_id/:income_id/:id/:menu" => "income_details#show", as: :show_household_member_unearned_income_detail
get "/household_registration/edit_household_member_unearned_income_detail/:client_id/:income_id/:id/:menu" => "income_details#edit", as: :edit_household_member_unearned_income_detail
put "/household_registration/update_household_member_unearned_income_detail/:client_id/:income_id/:id/:menu" => "income_details#update", as: :update_household_member_unearned_income_detail
delete "/household_registration/delete_household_member_unearned_income_detail/:client_id/:income_id/:id/:menu" => "income_details#destroy", as: :delete_household_member_unearned_income_detail
# unearned income details end

# unearned income detail adjustment reasons start
get "/household_registration/household_member_unearned_income_detail/income_detail_adjustment_reasons_index/:client_id/:income_detail_id/:menu"  => "income_detail_adjust_reasons#index", as: :household_member_unearned_income_detail_adjust_reasons_index
get "/household_registration/household_member_unearned_income_detail/new_income_detail_adjustment_reason/:client_id/:income_detail_id/:menu"  => "income_detail_adjust_reasons#new", as: :new_household_member_unearned_income_detail_adjust_reason
post "/household_registration/household_member_unearned_income_detail/create_income_detail_adjustment_reason/:client_id/:income_detail_id/:menu"  => "income_detail_adjust_reasons#create", as: :create_household_member_unearned_income_detail_adjust_reason

get "/household_registration/household_member_unearned_income_detail/show_income_detail_adjustment_reason/:client_id/:income_detail_id/:id/:menu" => "income_detail_adjust_reasons#show", as: :show_household_member_unearned_income_detail_adjust_reason

get "/household_registration/household_member_unearned_income_detail/edit_income_detail_adjustment_reason/:client_id/:income_detail_id/:id/:menu" => "income_detail_adjust_reasons#edit", as: :edit_household_member_unearned_income_detail_adjust_reason
put "/household_registration/household_member_unearned_income_detail/edit_income_detail_adjustment_reason/:client_id/:income_detail_id/:id/:menu" => "income_detail_adjust_reasons#update", as: :update_household_member_unearned_income_detail_adjust_reason

delete "/household_registration/household_member_unearned_income_detail/delete_income_detail_adjustment_reason/:client_id/:income_detail_id/:id/:menu" => "income_detail_adjust_reasons#destroy", as: :delete_household_member_unearned_income_detail_adjust_reason


# unearned income detail adjustment reasons end
# hh member unearned income step end
# Intake Management - Household Registration end

#login-logout

get "login/login"  => "logins#login", as: :login
get "login/logout"  => "logins#logout", as: :logout

# get "/interest_profiler_questions" => "interest_profiler_questions#index", as: :interest_profiler_questions
# get "/interest_profiler_questions/:id/show" => "interest_profiler_questions#show", as: :interest_profiler_questions_show
# get "/interest_profiler_questions/:id/edit_interest_profiler_question_wizard" => "interest_profiler_questions#edit_interest_profiler_question_wizard", as: :edit_interest_profiler_question_wizard
get "/assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize" => "interest_profiler_questions#interest_profiler_question_wizard_initialize", as: :interest_profiler_question_wizard_initialize
get "/assessment_careers/interest_profiler_questions/new" => "interest_profiler_questions#start_interest_profiler_question_wizard", as: :start_interest_profiler_question_wizard
post "/assessment_careers/interest_profiler_questions" => "interest_profiler_questions#process_interest_profiler_question_wizard", as: :process_interest_profiler_question_wizard
get "/assessment_careers/interest_profiler_questions/:report_code/career_details" => "interest_profiler_questions#career_details", as: :ipq_career_details
get "/assessment_careers/interest_profiler_questions/:report_code/save_career_details" => "interest_profiler_questions#save_career_details", as: :save_career_details
get "/assessment_careers/interest_profiler_questions/navigate_to_second_step" => "interest_profiler_questions#navigate_to_second_step", as: :navigate_to_second_step
get "/assessment_careers/interest_profiler_questions/clear_ipq_session_info" => "interest_profiler_questions#clear_ipq_session_info", as: :clear_ipq_session_info
# get "/interest_profiler_questions/cancel_wizard" => "interest_profiler_questions#cancel_wizard", as: :interest_profiler_questions_cancel_wizard

# get "application/application_processing/family_composition/determine_possible_cases" => "family_composition#determine_possible_cases", as: :determine_possible_cases
# post "application/application_processing/family_composition/determine_possible_cases" => "family_composition#create_case", as: :create_case
# get "application/application_processing/family_composition/back_to_application_processing_wizard" => "application_processing#back_to_application_processing_wizard", as: :back_to_application_processing_wizard




get "/application/application_processing/application_processing_wizard_initialize" => "application_processing#application_processing_wizard_initialize", as: :application_processing_wizard_initialize
get "/application/application_processing/:application_id/application_processing_wizard" => "application_processing#ready_for_processing", as: :ready_for_processing
get "/application/application_processing/application_processing_wizard" => "application_processing#start_application_processing_wizard", as: :start_application_processing_wizard
post "/application/application_processing/application_processing_wizard" => "application_processing#process_application_processing_wizard", as: :process_application_processing_wizard
get "/application/application_processing/:application_id/application_members" => "application_processing#edit_application_members", as: :edit_application_members
post "/application/application_processing/:application_id/application_members" => "application_processing#add_application_member", as: :add_application_member
get "/application/application_processing/race_information/index" => "application_processing#index_application_member_race", as: :index_application_member_race
get "/application/application_processing/race_information" => "application_processing#new_application_member_race", as: :new_application_member_race
post "/application/application_processing/race_information" => "application_processing#create_application_member_race", as: :create_application_member_race
get "/application/application_processing/:application_id/application_summary" => "application_processing#application_summary", as: :application_summary
get "/application/application_processing/:application_id/household_relations" => "application_processing#household_relations", as: :application_processing_household_relations
get "/program_unit/program_wizards/:program_unit_id/primary_beneficiary" => "program_units#primary_beneficiary", as: :primary_beneficiary
post "/program_unit/program_wizards/:program_unit_id/primary_beneficiary" => "program_units#add_primary_beneficiary", as: :add_primary_beneficiary

get "/program_unit/program_wizards/:program_unit_id/ebt_representative" => "program_unit_representatives#ebt_representative", as: :ebt_representative
post "/program_unit/program_wizards/:program_unit_id/ebt_representative" => "program_unit_representatives#add_ebt_representative", as: :add_ebt_representative
# Manoj 01/22/2016
get "/application/application_processing/:application_id/ready_for_application_processing" => "application_processing#ready_for_application_processing", as: :ready_for_application_processing
get "/application/application_processing/:household_id/:application_id/register_add_client_from_client_application" => "application_processing#register_add_client_from_client_application", as: :register_add_client_from_client_application

#household narative routes start
get "/household_narative/index" => "household_narative#index", as: :household_narative_index
get "/household_narative/new" => "household_narative#new", as: :household_narative_new
post "/household_narative/:household_id/create" => "household_narative#create", as: :household_narative_create
get "/household_narative/:client_id/show_client_narative" => "household_narative#show_client_narative", as: :show_client_narative

get "/household_narative/:entity_type/:entity_id/:long_description/show" => "household_narative#show", as: :household_narative_show
#household narative routes end




get "clients/contacts/contact_information" => "contacts#new", as: :new_contact
post "clients/contacts/contact_information"  => "contacts#validate_address", as: :validate_address
# get "clients/contacts/contact_information/confirm"  => "contacts#confirm", as: :confirm_contact_information
post "clients/contacts/contact_information/confirm"  => "contacts#create", as: :create_contact
get "clients/contacts/contact_information/show"  => "contacts#show", as: :show_contact_information

get "clients/navigator/eligible/program_units"  => "navigator#eligible_program_units", as: :eligible_program_units
post "clients/navigator/eligible/program_units"  => "navigator#create", as: :create_program_units
get "clients/navigator/eligible/program_unit/new"  => "navigator#new_program_unit", as: :new_program_unit
post "clients/navigator/eligible/program_unit/new"  => "navigator#create_new_program_unit", as: :create_new_program_unit
get "clients/navigator/validations"  => "navigator#navigator_validations", as: :navigator_validations
get "clients/navigator/reject"  => "navigator#reject_application", as: :reject_application
post "clients/navigator/reject"  => "navigator#create_application_rejection", as: :create_application_rejection
get "clients/navigator/deny"  => "navigator#deny_program_unit", as: :deny_program_unit
post "clients/navigator/deny"  => "navigator#create_program_unit_denial", as: :create_program_unit_denial


# VISHAL -HOUSEHOLD PGU TRANSFER START
get "program_unit_transfers/index" => "program_unit_transfers#index", as: :program_unit_transfer
get "program_unit_transfers/:program_unit_id/new" => "program_unit_transfers#new", as: :new_transfer
post "program_unit_transfers/:program_unit_id/create" => "program_unit_transfers#create", as: :create_transfer
# VISHAL -HOUSEHOLD PGU TRANSFER END


# MANOJ 03/31/2016 START

# custom routes for household absent parent start
 get "/household_absent_parent/index" => "household_client_parental_rspabilities#index", as: :household_absent_parents_index
 get "/household_absent_parent/show/:id" => "household_client_parental_rspabilities#show", as: :household_absent_parent_show
 get "/household_absent_parent/edit/:id" => "household_client_parental_rspabilities#edit", as: :household_absent_parent_edit
 put "/household_absent_parent/edit/:id" => "household_client_parental_rspabilities#update", as: :household_absent_parent_update
 # wizard start

 get "/household_absent_parent/new_household_absent_parents_wizard_initialize" => "household_client_parental_rspabilities#new_household_absent_parents_wizard_initialize", as: :new_household_absent_parents_wizard_initialize
 get "/household_absent_parent/start_household_member_registration_wizard" => "household_client_parental_rspabilities#start_household_absent_parents_wizard", as: :start_household_absent_parents_wizard
 post "/household_absent_parent/start_household_member_registration_wizard" => "household_client_parental_rspabilities#process_household_absent_parents_wizard", as: :process_household_absent_parents_wizard

 get "/household_absent_parent/change_absent_parent_wizard_initialize/:ab_parent_responsibility_id" => "household_client_parental_rspabilities#change_absent_parent_wizard_initialize", as: :change_absent_parent_wizard_initialize

# wizard end

# absent parent search & add/regsiter new absent parent
get "/household_absent_parent/new_household_absent_parent_search"  => "household_client_parental_rspabilities#new_household_absent_parent_search", as: :new_household_absent_parent_search
get "/household_absent_parent/household_absent_parent_search_results"  => "household_client_parental_rspabilities#household_absent_parent_search_results", as: :household_absent_parent_search_results
get "/household_absent_parent/:client_id/add_searched_absent_parent_into_current_household" => "household_client_parental_rspabilities#add_searched_absent_parent_into_current_household", as: :add_searched_absent_parent_into_current_household
# search -end
# absent_parent_demographics -start
get "/household_absent_parent/new_household_absent_parent"  => "household_client_parental_rspabilities#new_household_absent_parent", as: :new_household_absent_parent
post "/household_absent_parent/new_household_absent_parent"  => "household_client_parental_rspabilities#create_new_household_absent_parent", as: :create_new_household_absent_parent
get "/household_absent_parent/edit_household_absent_parent/:client_id" => "household_client_parental_rspabilities#edit_household_absent_parent", as: :edit_household_absent_parent
put "/household_absent_parent/edit_household_absent_parent/:client_id" => "household_client_parental_rspabilities#update_household_absent_parent", as: :update_household_absent_parent
# habsent_parent_demographics_demographics -start

# absent parent address start

get "/household_absent_parent/new_household_absent_parent_address" => "contacts#new", as: :new_household_absent_parent_address
post "/household_absent_parent/create_household_absent_parent_address" => "contacts#create", as: :create_household_absent_parent_address
get "/household_absent_parent/edit_household_absent_parent_address/:client_id"  => "contacts#new", as: :edit_household_absent_parent_address
post "/household_absent_parent/update_household_absent_parent_address"  => "contacts#create", as: :update_household_absent_parent_address
post "household_absent_parent/validate_address"  => "contacts#validate_address", as: :household_absent_parent_validate_address
# absent parent address end

# step 3- absent parent child relation  -start

get "/household_absent_parent/:absent_parent_client_id/new_absent_parent_child_relation" => "household_client_parental_rspabilities#new_absent_parent_child_relation", as: :new_absent_parent_child_relation
post "/household_absent_parent/:absent_parent_client_id/create_absent_parent_child_relation" => "household_client_parental_rspabilities#create_absent_parent_child_relation", as: :create_absent_parent_child_relation
get "household_absent_parent/:absent_parent_client_id/:child_client_id/deselect_absent_parent_child_relation" => "household_client_parental_rspabilities#deselect_absent_parent_child_relation", as: :deselect_absent_parent_child_relation
# step 3- absent parent child relation  -end

# step 4- absent parent responsibility  -start
get "/household_absent_parent/new_absent_parent_responsibility_information/:absent_parent_client_id"  => "household_client_parental_rspabilities#new_absent_parent_responsibility_information", as: :new_absent_parent_responsibility_information
post "/household_absent_parent/new_absent_parent_responsibility_information/:absent_parent_client_id"  => "household_client_parental_rspabilities#create_absent_parent_responsibility_information", as: :create_absent_parent_responsibility_information
# step 4- absent parent responsibility  -end

get "/household_absent_parent/absent_parent_return_to_household/:household_id/:absent_parent_client_id/:absent_parent_responsibility_id" => "household_client_parental_rspabilities#absent_parent_return_to_household", as: :absent_parent_return_to_household


# custom routes for household absent parent end
# ======================================================================================================

# custom routes for household address change start
get "/household_address_change/index" => "household_address_changes#index", as: :household_address_change_index

# household_address_change_wizard -start
get "/household_address_change/initialize_change_household_address_wizard/:current_address_id" => "household_address_changes#initialize_change_household_address_wizard", as: :initialize_change_household_address_wizard
get "/household_address_change/start_change_household_address_wizard/:new_household_address_id" => "household_address_changes#start_change_household_address_wizard", as: :start_change_household_address_wizard
post "/household_address_change/process_change_household_address_wizard/:new_household_address_id" => "household_address_changes#process_change_household_address_wizard", as: :process_change_household_address_wizard
get "/household_address_change/exit_change_household_address_wizard/:household_id" => "household_address_changes#exit_change_household_address_wizard", as: :exit_change_household_address_wizard
# household_address_change_wizard -end
# hh address step start
get "/household_address_change/new_household_address/:household_id"  => "household_address_changes#new_household_address", as: :new_household_address
post "/household_address_change/new_household_address/:household_id"  => "household_address_changes#validate_household_address", as: :validate_household_address
post "/household_address_change/create_new_address/:household_id/confirm"  => "household_address_changes#create_household_address", as: :create_household_address

get "/household_address_change/edit_household_address/:household_address_id/:household_id"  => "household_address_changes#edit_household_address", as: :edit_household_address
put "/household_address_change/verify_household_address/:household_address_id/:household_id"  => "household_address_changes#validate_household_address_for_edit", as: :validate_household_address_for_edit
put "/household_address_change/update_household_address/:household_address_id/:household_id/confirm"  => "household_address_changes#update_household_address", as: :update_household_address
# hh address step end

# household_address_change - add members moving to new address start
get "/household_address_change/:new_household_address_id/add_member_to_new_household_address" => "household_address_changes#new_member_to_new_household_address", as: :add_member_to_new_household_address
post "/household_address_change/:new_household_address_id/create_member_to_new_household_address" => "household_address_changes#create_member_to_new_household_address", as: :create_member_to_new_household_address
get "household_address_change/:new_household_address_id/:member_client_id/deselect_member_from_moving_to_new_address" => "household_address_changes#deselect_member_from_moving_to_new_address", as: :deselect_member_from_moving_to_new_address
# household_address_change - add members moving to new address end

# household with same residence address searched results found start
get "/household_address_change/household_with_same_address_search_results/:new_household_address_id/:current_household_id" => "household_address_changes#household_with_same_address_search_results", as: :household_with_same_address_search_results
get "/household_address_change/add_members_to_selected_household_address/:new_household_address_id/:selected_household_id/:selected_address_id" => "household_address_changes#add_members_to_selected_household_address", as: :add_members_to_selected_household_address
get "/household_address_change/create_new_household_after_address_search_from_change_address/:new_household_address_id" => "household_address_changes#create_new_household_after_address_search_from_change_address", as: :create_new_household_after_address_search_from_change_address
# household with same residence address searched results found end
# custom routes for household address change end
# MANOJ 03/31/2016 END

get "/schools/:from_client_management/new"  => "schools#new", as: :new_school_from_client_management
post "/schools/:from_client_management/create"  => "schools#create", as: :create_school_from_client_management

end