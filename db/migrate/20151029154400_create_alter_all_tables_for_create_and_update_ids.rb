class CreateAlterAllTablesForCreateAndUpdateIds < ActiveRecord::Migration
  def change


change_column :account_numbers, :created_by, :string
change_column :account_numbers, :updated_by, :string
change_column :action_plan_cpp_snapshots, :created_by, :string
change_column :action_plan_cpp_snapshots, :updated_by, :string
change_column :action_plan_cpp_snapshots, :action_plan_created_by, :string
change_column :action_plan_cpp_snapshots, :action_plan_updated_by, :string

change_column :action_plan_detail_cpp_snapshots, :created_by, :string
change_column :action_plan_detail_cpp_snapshots, :updated_by, :string
change_column :action_plan_detail_cpp_snapshots, :action_plan_detail_created_by, :string
change_column :action_plan_detail_cpp_snapshots, :action_plan_detail_updated_by, :string


change_column :action_plan_details, :created_by, :string
change_column :action_plan_details, :updated_by, :string
change_column :action_plans, :created_by, :string
change_column :action_plans, :updated_by, :string
change_column :activity_hour_cpp_snapshots, :created_by, :string
change_column :activity_hour_cpp_snapshots, :updated_by, :string
change_column :activity_hour_cpp_snapshots, :activity_hour_created_by, :string
change_column :activity_hour_cpp_snapshots, :activity_hour_updated_by, :string


change_column :activity_hours, :created_by, :string
change_column :activity_hours, :updated_by, :string
change_column :addresses, :created_by, :string
change_column :addresses, :updated_by, :string
change_column :agency_referrals, :created_by, :string
change_column :agency_referrals, :updated_by, :string
change_column :alerts, :created_by, :string
change_column :alerts, :updated_by, :string
change_column :alerts, :alert_assigned_to_user_id, :string


change_column :aliens, :created_by, :string
change_column :aliens, :updated_by, :string
change_column :application_members, :created_by, :string
change_column :application_members, :updated_by, :string
change_column :application_service_programs, :created_by, :string
change_column :application_service_programs, :updated_by, :string
change_column :assessment_barrier_cpp_snapshots, :created_by, :string
change_column :assessment_barrier_cpp_snapshots, :updated_by, :string
change_column :assessment_barrier_cpp_snapshots, :assessment_barrier_created_by, :string
change_column :assessment_barrier_cpp_snapshots, :assessment_barrier_updated_by, :string


change_column :assessment_barrier_detail_histories, :created_by, :string
change_column :assessment_barrier_detail_histories, :updated_by, :string
change_column :assessment_barrier_detail_histories, :client_assessment_barrier_detail_created_by, :string
change_column :assessment_barrier_detail_histories, :client_assessment_barrier_detail_updated_by, :string


change_column :assessment_barrier_details, :created_by, :string
change_column :assessment_barrier_details, :updated_by, :string
change_column :assessment_barrier_details_cpp_snapshots, :created_by, :string
change_column :assessment_barrier_details_cpp_snapshots, :updated_by, :string
change_column :assessment_barrier_details_cpp_snapshots, :assessment_barrier_detail_created_by, :string
change_column :assessment_barrier_details_cpp_snapshots, :assessment_barrier_detail_updated_by, :string


change_column :assessment_barrier_histories, :created_by, :string
change_column :assessment_barrier_histories, :updated_by, :string
change_column :assessment_barrier_histories, :client_assessment_barrier_created_by, :string
change_column :assessment_barrier_histories, :client_assessment_barrier_updated_by, :string

change_column :assessment_barrier_recommendation_cpp_snapshots, :created_by, :string
change_column :assessment_barrier_recommendation_cpp_snapshots, :updated_by, :string
change_column :assessment_barrier_recommendation_cpp_snapshots, :assessment_barrier_recommendation_created_by, :string
change_column :assessment_barrier_recommendation_cpp_snapshots, :assessment_barrier_recommendation_updated_by, :string

change_column :assessment_barrier_recommendation_histories, :created_by, :string
change_column :assessment_barrier_recommendation_histories, :updated_by, :string
change_column :assessment_barrier_recommendation_histories, :client_assessment_barrier_recommendation_created_by, :string
change_column :assessment_barrier_recommendation_histories, :client_assessment_barrier_recommendation_updated_by, :string

change_column :assessment_barrier_recommendations, :created_by, :string
change_column :assessment_barrier_recommendations, :updated_by, :string
change_column :assessment_barriers, :created_by, :string
change_column :assessment_barriers, :updated_by, :string
change_column :assessment_question_metadata, :created_by, :string
change_column :assessment_question_metadata, :updated_by, :string
change_column :assessment_question_multi_responses, :created_by, :string
change_column :assessment_question_multi_responses, :updated_by, :string
change_column :assessment_questions, :created_by, :string
change_column :assessment_questions, :updated_by, :string
change_column :assessment_sections, :created_by, :string
change_column :assessment_sections, :updated_by, :string
change_column :assessment_strength_histories, :created_by, :string
change_column :assessment_strength_histories, :updated_by, :string
change_column :assessment_strength_histories, :client_assessment_strength_created_by, :string
change_column :assessment_strength_histories, :client_assessment_strength_updated_by, :string

change_column :assessment_strengths, :created_by, :string
change_column :assessment_strengths, :updated_by, :string
change_column :assessment_strengths_cpp_snapshots, :created_by, :string
change_column :assessment_strengths_cpp_snapshots, :updated_by, :string
change_column :assessment_strengths_cpp_snapshots, :assessment_strength_created_by, :string
change_column :assessment_strengths_cpp_snapshots, :assessment_strength_updated_by, :string

change_column :assessment_sub_sections, :created_by, :string
change_column :assessment_sub_sections, :updated_by, :string
change_column :attop_error_logs, :created_by, :string
change_column :audit_trail_expense_details, :created_by, :string
change_column :audit_trail_expense_details, :updated_by, :string
change_column :audit_trail_expense_detail_secs, :created_by, :string
change_column :audit_trail_expense_detail_secs, :updated_by, :string
change_column :audit_trail_inc_adjs, :created_by, :string
change_column :audit_trail_inc_adjs, :updated_by, :string
change_column :audit_trail_inc_adj_secs, :created_by, :string
change_column :audit_trail_inc_adj_secs, :updated_by, :string
change_column :audit_trail_inc_detail_secs, :created_by, :string
change_column :audit_trail_inc_detail_secs, :updated_by, :string
change_column :audit_trail_income_details, :created_by, :string
change_column :audit_trail_income_details, :updated_by, :string
change_column :audit_trail_masters, :created_by, :string
change_column :audit_trail_masters, :updated_by, :string
change_column :audit_trail_master_secs, :created_by, :string
change_column :audit_trail_master_secs, :updated_by, :string
change_column :audit_trail_res_details, :created_by, :string
change_column :audit_trail_res_details, :updated_by, :string
change_column :audit_trail_res_detail_secs, :created_by, :string
change_column :audit_trail_res_detail_secs, :updated_by, :string
change_column :audit_trail_shareds, :created_by, :string
change_column :audit_trail_shareds, :updated_by, :string
change_column :audit_trail_shared_secs, :created_by, :string
change_column :audit_trail_shared_secs, :updated_by, :string
change_column :barriers, :created_by, :string
change_column :barriers, :updated_by, :string
change_column :benefits, :created_by, :string
change_column :benefits, :updated_by, :string
change_column :budget_units, :created_by, :string
change_column :budget_units, :updated_by, :string
change_column :career_pathway_plans, :created_by, :string
change_column :career_pathway_plans, :updated_by, :string
change_column :career_pathway_plans, :case_worker_signature, :string
change_column :career_pathway_plans, :supervisor_signature, :string

change_column :career_pathway_plan_state_transitions, :created_by, :string
change_column :client_activities, :created_by, :string
change_column :client_activities, :updated_by, :string
change_column :client_activity_services, :created_by, :string
change_column :client_activity_services, :updated_by, :string
change_column :client_addresses, :created_by, :string
change_column :client_addresses, :updated_by, :string
change_column :client_applications, :created_by, :string
change_column :client_applications, :updated_by, :string
change_column :client_applications, :intake_worker_id, :string

change_column :client_assessment_answer_histories, :created_by, :string
change_column :client_assessment_answer_histories, :updated_by, :string
change_column :client_assessment_answer_histories, :client_assessment_answer_created_by, :string
change_column :client_assessment_answer_histories, :client_assessment_answer_updated_by, :string

change_column :client_assessment_answers, :created_by, :string
change_column :client_assessment_answers, :updated_by, :string
change_column :client_assessment_answers_cpp_snapshots, :created_by, :string
change_column :client_assessment_answers_cpp_snapshots, :updated_by, :string
change_column :client_assessment_answers_cpp_snapshots, :client_assessment_answer_created_by, :string
change_column :client_assessment_answers_cpp_snapshots, :client_assessment_answer_updated_by, :string

change_column :client_assessment_cpp_snapshots, :created_by, :string
change_column :client_assessment_cpp_snapshots, :updated_by, :string
change_column :client_assessment_cpp_snapshots, :client_assessment_created_by, :string
change_column :client_assessment_cpp_snapshots, :client_assessment_updated_by, :string


change_column :client_assessment_histories, :created_by, :string
change_column :client_assessment_histories, :updated_by, :string
change_column :client_assessment_histories, :client_assessment_created_by, :string
change_column :client_assessment_histories, :client_assessment_updated_by, :string


change_column :client_assessments, :created_by, :string
change_column :client_assessments, :updated_by, :string
change_column :client_barriers, :created_by, :string
change_column :client_barriers, :updated_by, :string
change_column :client_barriers, :barrier_identfied_by, :string


change_column :client_characteristics, :created_by, :string
change_column :client_characteristics, :updated_by, :string
change_column :client_doc_verfications, :created_by, :string
change_column :client_doc_verfications, :updated_by, :string
change_column :client_expenses, :created_by, :string
change_column :client_expenses, :updated_by, :string
change_column :client_immunizations, :created_by, :string
change_column :client_immunizations, :updated_by, :string
change_column :client_incomes, :created_by, :string
change_column :client_incomes, :updated_by, :string
change_column :client_notes, :created_by, :string
change_column :client_notes, :updated_by, :string
change_column :client_parental_rspabilities, :created_by, :string
change_column :client_parental_rspabilities, :updated_by, :string
change_column :client_races, :created_by, :string
change_column :client_races, :updated_by, :string
change_column :client_referrals, :created_by, :string
change_column :client_referrals, :updated_by, :string
change_column :client_relationships, :created_by, :string
change_column :client_relationships, :updated_by, :string
change_column :client_resources, :created_by, :string
change_column :client_resources, :updated_by, :string
  change_column :clients, :created_by, :string
  change_column :clients, :updated_by, :string
change_column :client_sanctions, :created_by, :string
change_column :client_sanctions, :updated_by, :string
change_column :client_scores, :created_by, :string
change_column :client_scores, :updated_by, :string
change_column :client_skills, :created_by, :string
change_column :client_skills, :updated_by, :string
change_column :client_skills, :skill_identfied_by, :string

change_column :comments, :created_by, :string
change_column :comments, :updated_by, :string
change_column :cost_centers, :created_by, :string
change_column :cost_centers, :updated_by, :string
change_column :disabilities, :created_by, :string
change_column :disabilities, :updated_by, :string
change_column :educations, :created_by, :string
change_column :educations, :updated_by, :string
change_column :eligibility_determine_results, :created_by, :string
change_column :eligibility_determine_results, :updated_by, :string
change_column :employers, :created_by, :string
change_column :employers, :updated_by, :string
change_column :employment_details, :created_by, :string
change_column :employment_details, :updated_by, :string
# change_column :employment_plans, :created_by, :string
# change_column :employment_plans, :updated_by, :string
change_column :employment_readiness_plan_cpp_snapshots, :created_by, :string
change_column :employment_readiness_plan_cpp_snapshots, :updated_by, :string
change_column :employment_readiness_plan_cpp_snapshots, :employment_readiness_plan_created_by, :string
change_column :employment_readiness_plan_cpp_snapshots, :employment_readiness_plan_updated_by, :string


change_column :employment_readiness_plans, :created_by, :string
change_column :employment_readiness_plans, :updated_by, :string
change_column :employments, :created_by, :string
change_column :employments, :updated_by, :string
change_column :entity_addresses, :created_by, :string
change_column :entity_addresses, :updated_by, :string
change_column :entity_phones, :created_by, :string
change_column :entity_phones, :updated_by, :string
change_column :entity_question_answers, :created_by, :string
change_column :entity_question_answers, :updated_by, :string
change_column :event_to_actions_mappings, :created_by, :string
change_column :event_to_actions_mappings, :updated_by, :string
change_column :expected_work_participation_hours, :created_by, :string
change_column :expected_work_participation_hours, :updated_by, :string
change_column :expense_details, :created_by, :string
change_column :expense_details, :updated_by, :string
change_column :expenses, :created_by, :string
change_column :expenses, :updated_by, :string
change_column :household_members, :created_by, :string
change_column :household_members, :updated_by, :string
change_column :households, :created_by, :string
change_column :households, :updated_by, :string
change_column :immunizations, :created_by, :string
change_column :immunizations, :updated_by, :string
change_column :income_detail_adjust_reasons, :created_by, :string
change_column :income_detail_adjust_reasons, :updated_by, :string
change_column :income_details, :created_by, :string
change_column :income_details, :updated_by, :string
change_column :incomes, :created_by, :string
change_column :incomes, :updated_by, :string
change_column :in_state_payments, :created_by, :string
change_column :in_state_payments, :updated_by, :string
change_column :local_office_informations, :created_by, :string
change_column :local_office_informations, :updated_by, :string
change_column :nightly_batch_processes, :created_by, :string
change_column :nightly_batch_processes, :updated_by, :string
change_column :notes, :created_by, :string
change_column :notes, :updated_by, :string
change_column :notice_generation_details, :created_by, :string
change_column :notice_generation_details, :updated_by, :string
change_column :notice_generations, :created_by, :string
change_column :notice_generations, :updated_by, :string
change_column :notice_texts, :created_by, :string
change_column :notice_texts, :updated_by, :string
change_column :outcomes, :created_by, :string
change_column :outcomes, :updated_by, :string
change_column :outcomes, :recorded_worker, :string


change_column :out_of_state_payments, :created_by, :string
change_column :out_of_state_payments, :updated_by, :string
change_column :payment_line_items, :created_by, :string
change_column :payment_line_items, :updated_by, :string
change_column :phones, :created_by, :string
change_column :phones, :updated_by, :string
change_column :potential_intake_clients, :created_by, :string
change_column :potential_intake_clients, :updated_by, :string
change_column :pregnancies, :created_by, :string
change_column :pregnancies, :updated_by, :string
change_column :prescreen_assessment_answers, :created_by, :string
change_column :prescreen_assessment_answers, :updated_by, :string
# change_column :pre_screenings, :created_by, :string
# change_column :pre_screenings, :updated_by, :string
change_column :program_benefit_details, :created_by, :string
change_column :program_benefit_details, :updated_by, :string
change_column :program_benefit_members, :created_by, :string
change_column :program_benefit_members, :updated_by, :string
change_column :program_member_details, :created_by, :string
change_column :program_member_details, :updated_by, :string
change_column :program_member_summaries, :created_by, :string
change_column :program_member_summaries, :updated_by, :string
change_column :program_month_summaries, :created_by, :string
change_column :program_month_summaries, :updated_by, :string
change_column :program_standard_details, :created_by, :string
change_column :program_standard_details, :updated_by, :string
change_column :program_standards, :created_by, :string
change_column :program_standards, :updated_by, :string
change_column :program_unit_members, :created_by, :string
change_column :program_unit_members, :updated_by, :string
change_column :program_unit_participations, :created_by, :string
change_column :program_unit_participations, :updated_by, :string
change_column :program_unit_representatives, :created_by, :string
change_column :program_unit_representatives, :updated_by, :string
change_column :program_units, :created_by, :string
change_column :program_units, :updated_by, :string

change_column :program_units, :case_manager_id, :string
change_column :program_units, :eligibility_worker_id, :string




change_column :program_unit_size_standard_details, :created_by, :string
change_column :program_unit_size_standard_details, :updated_by, :string
change_column :program_unit_size_standards, :created_by, :string
change_column :program_unit_size_standards, :updated_by, :string
change_column :program_unit_state_transitions, :created_by, :string
change_column :program_unit_task_owners, :created_by, :string
change_column :program_unit_task_owners, :updated_by, :string

change_column :program_unit_task_owners, :ownership_user_id, :string


change_column :program_wizard_reasons, :created_by, :string
change_column :program_wizard_reasons, :updated_by, :string
change_column :program_wizards, :created_by, :string
change_column :program_wizards, :updated_by, :string
change_column :provider_agreement_areas, :created_by, :string
change_column :provider_agreement_areas, :updated_by, :string
change_column :provider_agreements, :created_by, :string
change_column :provider_agreements, :updated_by, :string

change_column :provider_agreements, :dws_local_office_manager_id, :string


change_column :provider_agreement_state_transitions, :created_by, :string
change_column :provider_invoice_histories, :created_by, :string

change_column :provider_invoice_histories, :invoice_created_by, :string
change_column :provider_invoice_histories, :invoice_updated_by, :string



change_column :provider_invoices, :created_by, :string
change_column :provider_invoices, :updated_by, :string
change_column :provider_invoice_state_transitions, :created_by, :string
change_column :provider_languages, :created_by, :string
change_column :provider_languages, :updated_by, :string
change_column :providers, :created_by, :string
change_column :providers, :updated_by, :string
change_column :providers, :intake_worker_id, :string




change_column :provider_service_area_availabilities, :created_by, :string
change_column :provider_service_area_availabilities, :updated_by, :string
change_column :provider_service_areas, :created_by, :string
change_column :provider_service_areas, :updated_by, :string
change_column :provider_services, :created_by, :string
change_column :provider_services, :updated_by, :string
change_column :recommendations, :created_by, :string
change_column :recommendations, :updated_by, :string
change_column :resource_adjustments, :created_by, :string
change_column :resource_adjustments, :updated_by, :string
change_column :resource_details, :created_by, :string
change_column :resource_details, :updated_by, :string
change_column :resources, :created_by, :string
change_column :resources, :updated_by, :string
change_column :resource_uses, :created_by, :string
change_column :resource_uses, :updated_by, :string
change_column :roles, :created_by_user_id, :string
change_column :roles, :updated_by_user_id, :string
change_column :ruby_elements, :created_by_user_id, :string
change_column :ruby_elements, :updated_by_user_id, :string
change_column :rule_adjustments, :created_by, :string
change_column :rule_adjustments, :updated_by, :string
change_column :rule_date_param_details, :created_by, :string
change_column :rule_date_param_details, :updated_by, :string
change_column :rule_date_params, :created_by, :string
change_column :rule_date_params, :updated_by, :string
change_column :rule_details, :created_by, :string
change_column :rule_details, :updated_by, :string
change_column :rule_disallows, :created_by, :string
change_column :rule_disallows, :updated_by, :string
change_column :rule_results, :created_by, :string
change_column :rule_results, :updated_by, :string
change_column :rules, :created_by, :string
change_column :rules, :updated_by, :string
change_column :sanction_details, :created_by, :string
change_column :sanction_details, :updated_by, :string
change_column :sanctions, :created_by, :string
change_column :sanctions, :updated_by, :string
change_column :schedule_cpp_snapshots, :created_by, :string
change_column :schedule_cpp_snapshots, :updated_by, :string

change_column :schedule_cpp_snapshots, :action_plan_schedule_created_by, :string
change_column :schedule_cpp_snapshots, :action_plan_schedule_updated_by, :string



change_column :schedule_extensions, :created_by, :string
change_column :schedule_extensions, :updated_by, :string
change_column :schedules, :created_by, :string
change_column :schedules, :updated_by, :string
change_column :schools, :created_by, :string
change_column :schools, :updated_by, :string
change_column :screening_engines, :created_by, :string
change_column :screening_engines, :updated_by, :string
change_column :service_authorization_cpp_snapshots, :created_by, :string
change_column :service_authorization_cpp_snapshots, :updated_by, :string

change_column :service_authorization_cpp_snapshots, :service_authorization_created_by, :string
change_column :service_authorization_cpp_snapshots, :service_authorization_updated_by, :string




change_column :service_authorization_line_item_histories, :created_by, :string

change_column :service_authorization_line_item_histories, :service_authorization_created_by, :string
change_column :service_authorization_line_item_histories, :service_authorization_updated_by, :string


change_column :service_authorization_line_items, :created_by, :string
change_column :service_authorization_line_items, :updated_by, :string
change_column :service_authorization_line_items_invoices, :created_by, :string
change_column :service_authorization_line_items_invoices, :updated_by, :string
change_column :service_authorization_line_item_state_transitions, :created_by, :string
change_column :service_authorizations, :created_by, :string
change_column :service_authorizations, :updated_by, :string
change_column :service_programs, :created_by, :string
change_column :service_programs, :updated_by, :string
change_column :service_schedules, :created_by, :string
change_column :service_schedules, :updated_by, :string
change_column :standard_recommendations, :created_by, :string
change_column :standard_recommendations, :updated_by, :string
change_column :supl_retro_bns_payments, :created_by, :string
change_column :supl_retro_bns_payments, :updated_by, :string
change_column :system_param_categories, :created_by, :string
change_column :system_param_categories, :updated_by, :string
change_column :system_params, :created_by, :string
change_column :system_params, :updated_by, :string
change_column :time_limits, :created_by, :string
change_column :time_limits, :updated_by, :string
change_column :user_local_offices, :created_by, :string
change_column :user_local_offices, :updated_by, :string

change_column :user_local_offices, :user_id, :string



change_column :users, :created_by, :string
change_column :users, :updated_by, :string
change_column :work_queue_local_office_subscriptions, :created_by, :string
change_column :work_queue_local_office_subscriptions, :updated_by, :string
change_column :work_queues, :created_by, :string
change_column :work_queues, :updated_by, :string
change_column :work_queue_state_transitions, :created_by, :string
change_column :work_queue_user_subscriptions, :created_by, :string
change_column :work_queue_user_subscriptions, :updated_by, :string

change_column :work_queue_user_subscriptions, :user_id, :string


change_column :work_tasks, :created_by, :string
change_column :work_tasks, :updated_by, :string

change_column :work_tasks, :assigned_to_id, :string
change_column :work_tasks, :assigned_by_user_id, :string





  end
end
