
namespace :assessment_questions_population_dbseed do
	desc "Assessment Question data population job"
	task :seed => :environment do
		# ***************************TABLES START**************************************
		# 1. recommendations
		# 2. assessment_sections
		# 3. assessment_sub_sections
		# 4. barriers
		# 5. standard_recommendations
		# 6. assessment_questions
		# 7. assessment_question_multi_responses
		# 8. assessment_question_metadata
		# ***************************TABLES END**************************************

		# 1.recommendations
		Rake::Task["recommendation_data_population_task:populate_recommendations"].invoke
		# 2.assessment_sections
		Rake::Task["assessment_section_task1:assessment_section"].invoke
		# 3.assessment_sub_sections
		Rake::Task["assessment_sub_section_task2:assessment_sub_section"].invoke
		# 4. barriers
		Rake::Task["barrier_data_population_task:populate_barriers"].invoke
		# 5. standard_recommendations
		Rake::Task["barrier_to_recommendation_mapping_task:populate_barrier_to_recommendation_mapping"].invoke
		# 6. assessment_questions
		Rake::Task["assessment_questions_task4:assessment_questions"].invoke
		# 7. assessment_question_multi_responses
		Rake::Task["assessment_questions_multi_response_education_english_task5:assessment_education_english"].invoke
		# 8. assessment_question_metadata
		Rake::Task["assessment_questions_mtdt_education_english_task6:assessment_questions_mtdt_english"].invoke


		Rake::Task["assessment_questions_multi_response_education_learning_difficulties_task7:assessment_education_lrng_difficlty"].invoke
		Rake::Task["assessment_questions_mtdt_education_lrng_difficlty_task8:assessment_questions_mtdt_lrng_difficlty"].invoke
		Rake::Task["assessment_questions_mtdt_education_other_edu_certificate_task9:assessment_questions_mtdt_other_edu_cert"].invoke
		Rake::Task["assessment_questions_multi_response_education_other_edu_certificate_task10:assessment_education_multi_rspnse_other_edu_certificate"].invoke
		Rake::Task["assessment_questions_mtdt_education_highest_grade_task11:assessment_questions_mtdt_highest_grade"].invoke
		Rake::Task["assessment_questions_multi_response_education_highest_grade_task12:assessment_education_multi_rspnse_highest_grade"].invoke
		Rake::Task["assessment_questions_mtdt_education_diploma_degree_task13:assessment_questions_mtdt_diploma_degree"].invoke
		Rake::Task["assessment_questions_mtdt_employment_work_interest_task14:assessment_questions_mtdt_employment_wrk_interests"].invoke
		Rake::Task["assessment_questions_multi_response_employment_work_interests_task15:assessment_education_multi_rspnse_employment_work_interests"].invoke
		Rake::Task["assessment_questions_mtdt_employment_career_interest_task16:assessment_questions_mtdt_employment_career_interests"].invoke
		Rake::Task["assessment_questions_multi_response_employment_career_interests_task17:assessment_education_multi_rspnse_employment_career_interests"].invoke
		Rake::Task["assessment_questions_mtdt_employment_currently_working_task18:assessment_questions_mtdt_employment_currently_working"].invoke
		Rake::Task["assessment_questions_multi_response_employment_currently_working_task19:assessment_education_multi_rspnse_employment_currently_working"].invoke
		Rake::Task["assessment_questions_mtdt_employment_reasons_not_working_task20:assessment_questions_mtdt_employment_reasons_not_working"].invoke
		Rake::Task["assessment_questions_multi_response_employment_reasons_not_working_task21:assessment_questions_multi_response_employment_reasons_not_working"].invoke
		Rake::Task["assessment_questions_mtdt_employment_legal_barriers_task22:assessment_questions_mtdt_employment_legal_barriers"].invoke
		Rake::Task["assessment_questions_multi_response_employment_legal_barriers_task23:assessment_questions_multi_response_employment_legal_barriers"].invoke
		Rake::Task["assessment_questions_mtdt_employment_experience_task24:assessment_questions_mtdt_employment_experience"].invoke
		Rake::Task["assessment_questions_multi_response_employment_experience_task25:assessment_questions_multi_response_employment_experience"].invoke
		Rake::Task["assessment_questions_mtdt_employment_spoken_language_task26:assessment_questions_mtdt_employment_spoken_language"].invoke
		Rake::Task["assessment_questions_multi_response_employment_spoken_language_task27:assessment_questions_multi_response_employment_spoken_language"].invoke
		Rake::Task["assessment_questions_mtdt_housing_current_housing_task28:assessment_questions_mtdt_housing_current_housing"].invoke
		Rake::Task["assessment_questions_multi_response_housing_current_housing_task29:assessment_questions_multi_response_housing_current_housing"].invoke
		Rake::Task["assessment_questions_mtdt_housing_housing_situation_task30:assessment_questions_mtdt_housing_housing_situation"].invoke
		Rake::Task["assessment_questions_multi_response_housing_housing_situation_task31:assessment_questions_multi_response_housing_housing_situation"].invoke
		Rake::Task["assessment_questions_mtdt_transportation_transportation_method_task32:assessment_questions_mtdt_transportation_transportation_method"].invoke
		Rake::Task["assessment_questions_multi_response_transportation_transportation_method_task33:assessment_questions_multi_response_transportation_transportation_method"].invoke
		Rake::Task["assessment_questions_mtdt_transportation_driving_license_task34:assessment_questions_mtdt_transportation_driving_license"].invoke
		Rake::Task["assessment_questions_multi_response_transportation_driver_licence_task35:assessment_questions_multi_response_transportation_driver_licence"].invoke
		Rake::Task["assessment_questions_mtdt_transportation_transportation_challenge_task36:assessment_questions_mtdt_transportation_transportation_challenge"].invoke
		Rake::Task["assessment_questions_multi_response_transportation_transportation_challenge_task37:assessment_questions_multi_response_transportation_transportation_challenge"].invoke
		Rake::Task["assessment_questions_mtdt_gen_health_current_health_task38:assessment_questions_mtdt_gen_health_current_health"].invoke
		Rake::Task["assessment_questions_multi_response_gen_health_current_health_task39:assessment_questions_multi_response_gen_health_current_health"].invoke
		Rake::Task["assessment_questions_mtdt_gen_health_health_challenge_task40:assessment_questions_mtdt_gen_health_health_challenge"].invoke
		Rake::Task["assessment_questions_multi_response_gen_health_health_challenge_task41:assessment_questions_multi_response_gen_health_health_challenge"].invoke
		Rake::Task["assessment_questions_mtdt_men_health_mental_health_task42:assessment_questions_mtdt_men_health_mental_health"].invoke
		Rake::Task["assessment_questions_multi_response_men_health_mental_health_task43:assessment_questions_multi_response_men_health_mental_health"].invoke
		Rake::Task["assessment_questions_mtdt_men_health_diagnosis_task44:assessment_questions_mtdt_men_health_diagnosis"].invoke
		Rake::Task["assessment_questions_multi_response_men_health_diagnosis_task45:assessment_questions_multi_response_men_health_diagnosis"].invoke
		Rake::Task["assessment_questions_mtdt_sub_abuse_alco_and_drugs_task46:assessment_questions_mtdt_sub_abuse_alco_and_drugs"].invoke
		Rake::Task["assessment_questions_multi_response_sub_abuse_alco_and_drugs_task47:assessment_questions_multi_response_sub_abuse_alco_and_drugs"].invoke
		Rake::Task["assessment_questions_mtdt_sub_abuse_household_drugs_task48:assessment_questions_mtdt_sub_abuse_household_drugs"].invoke
		Rake::Task["assessment_questions_multi_response_sub_abuse_household_drugs_task49:assessment_questions_multi_response_sub_abuse_household_drugs"].invoke
		Rake::Task["assessment_questions_mtdt_dom_viol_victim_task50:assessment_questions_mtdt_dom_viol_victim"].invoke
		Rake::Task["assessment_questions_multi_response_dom_viol_victim_task51:assessment_questions_multi_response_dom_viol_victim"].invoke
		Rake::Task["assessment_questions_mtdt_dom_viol_perpetrator_task52:assessment_questions_mtdt_dom_viol_perpetrator"].invoke
		Rake::Task["assessment_questions_multi_response_dom_viol_perpetrator_task53:assessment_questions_multi_response_dom_viol_perpetrator"].invoke
		Rake::Task["assessment_questions_mtdt_pregnancy_task54:assessment_questions_mtdt_pregnancy"].invoke
		Rake::Task["assessment_questions_multi_response_pregnancy_task55:assessment_questions_multi_response_pregnancy"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_child_issues_task56:assessment_questions_mtdt_child_care_child_issues"].invoke
		Rake::Task["assessment_questions_multi_response_child_care_child_issues_task57:assessment_questions_multi_response_child_care_child_issues"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_primary_caregiver_task58:assessment_questions_mtdt_child_care_primary_caregiver"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_parenting_and_child_support_task59:assessment_questions_mtdt_child_care_parenting_and_child_support"].invoke
		Rake::Task["assessment_questions_multi_response_child_care_parenting_and_child_support_task60:assessment_questions_multi_response_child_care_parenting_and_child_support"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_childcare_task61:assessment_questions_mtdt_child_care_childcare"].invoke
		Rake::Task["assessment_questions_multi_response_child_care_childcare_task62:assessment_questions_multi_response_child_care_childcare"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_backup_childcare_task63:assessment_questions_mtdt_child_care_backup_childcare"].invoke
		Rake::Task["assessment_questions_multi_response_child_care_backup_childcare_task64:assessment_questions_multi_response_child_care_backup_childcare"].invoke
		Rake::Task["assessment_questions_mtdt_relationship_relationship_task65:assessment_questions_mtdt_relationship_relationship"].invoke
		Rake::Task["assessment_questions_multi_response_relationship_relationship_task66:assessment_questions_multi_response_relationship_relationship"].invoke
		Rake::Task["assessment_questions_mtdt_final_thoughts_closing_questions_task67:assessment_questions_mtdt_final_thoughts_closing_questions"].invoke
		Rake::Task["assessment_questions_multi_response_final_thoughts_closing_questions_task68:assessment_questions_multi_response_final_thoughts_closing_questions"].invoke
		Rake::Task["assessment_questions_mtdt_child_care_childcare_status_task69:assessment_questions_mtdt_child_care_childcare_status"].invoke
		Rake::Task["assessment_questions_multi_response_child_care_childcare_status_task70:assessment_questions_multi_response_child_care_childcare_status"].invoke

		Rake::Task["assessment_questions_mtdt_demographics_finance_task71:assessment_questions_mtdt_demographics_finance"].invoke
		Rake::Task["assessment_questions_multi_response_demographics_finace_task72:assessment_demographics_finance"].invoke
		Rake::Task["update_assessment_questions_for_transportation:update_assessment_questions_for_transportation"].invoke
		Rake::Task["assessment_questions_modified_for_childcare_and_parenting:assessment_questions_modified_for_childcare_and_parenting"].invoke
		Rake::Task["assessment_questions_sort_order_fix1:assessment_questions_sort_order_fix1"].invoke
		Rake::Task["assessment_questions_modified_for_housing:assessment_questions_modified_for_housing"].invoke
		Rake::Task["assessment_questions_modified_for_pregnancy:assessment_questions_modified_for_pregnancy"].invoke
        Rake::Task["update_assessment_questions_modified_for_pregnancy_metadatatype:update_assessment_questions_modified_for_pregnancy_metadatatype"].invoke
        Rake::Task["update_assessment_questions_for_employment:update_assessment_questions_for_employment"].invoke
        Rake::Task["assessment_questions_modified_for_general_health:assessment_questions_modified_for_general_health"].invoke
        Rake::Task["update_assessment_questions_for_substance_abuse:update_assessment_questions_for_substance_abuse"].invoke
        Rake::Task["update_assessment_questions_for_childcare_and_parenting:update_assessment_questions_for_childcare_and_parenting"].invoke
        Rake::Task["assessment_questions_modified_for_mental_health:assessment_questions_modified_for_mental_health"].invoke
        Rake::Task["update_assessment_questions_for_transportation2:update_assessment_questions_for_transportation2"].invoke
        Rake::Task["update_assessment_questions_for_domestic_violence:update_assessment_questions_for_domestic_violence"].invoke
        Rake::Task["update_assessment_questions_for_child_care_parenting:update_assessment_questions_for_child_care_parenting"].invoke
        Rake::Task["update_assessment_questions_for_drivers_license:update_assessment_questions_for_drivers_license"].invoke
        # prescreen household cirumstances assessment questions -start
   		Rake::Task["prescreen_assessment_questions:prescreen_assessment_questions"].invoke
		Rake::Task["additional_prescreen_assessment_questions:additional_prescreen_assessment_questions"].invoke
		# prescreen household cirumstances assessment questions -end
		Rake::Task["assessment_questions_delete_task:delete_task"].invoke
		Rake::Task["assessment_section_for_testing_service:assessment_section_for_testing_service"].invoke
		Rake::Task["update_assessment_employment_tea_diversion:update_assessment_employment_tea_diversion"].invoke
		Rake::Task["assessment_employment_tea_diversion_update_questions:assessment_employment_tea_diversion_update_questions"].invoke
        Rake::Task["assessment_questions_multi_response_and_metadata_added_for_currently_working:assessment_questions_multi_response_and_metadata_added_for_currently_working"].invoke
        Rake::Task["assessment_question_deleted:assessment_question_deleted_from_child_care_and_parenting"].invoke
        Rake::Task["assessment_question_vaccination_deleted:assessment_question_vaccination_deleted"].invoke
        Rake::Task["update_assessment_question_for_employment:update_assessment_question_for_employment"].invoke








    end
end