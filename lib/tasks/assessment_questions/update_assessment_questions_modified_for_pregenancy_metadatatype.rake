namespace :update_assessment_questions_modified_for_pregnancy_metadatatype do
	desc "Assessment questions modified for pregnency"
	task :update_assessment_questions_modified_for_pregnancy_metadatatype => :environment do


           AssessmentQuestionMetadatum.where("assessment_question_id = 741 and id = 435 ").update_all(response_data_type:"RADIOGROUP")

   end
end