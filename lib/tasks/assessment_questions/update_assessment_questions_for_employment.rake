namespace :update_assessment_questions_for_employment do
	desc "updating Assessment Questions for employment "
	task :update_assessment_questions_for_employment => :environment do
		AssessmentQuestion.find(88).update(assessment_sub_section_id: 2  ,	display_order:7	)
		AssessmentQuestion.find(6).update(assessment_sub_section_id: 2  ,	display_order:8	)
		AssessmentQuestion.find(7).update(assessment_sub_section_id: 2  ,	display_order:9	)
		AssessmentQuestion.find(8).update(assessment_sub_section_id: 2  ,	display_order:10)
		AssessmentQuestion.find(9).update(assessment_sub_section_id: 2  ,	display_order:11)
		AssessmentQuestion.find(10).update(assessment_sub_section_id: 2  ,	display_order:12)
		AssessmentQuestion.find(11).update(assessment_sub_section_id: 2  ,	display_order:13)
		AssessmentQuestion.find(12).update(assessment_sub_section_id: 2  ,	display_order:14)
		AssessmentQuestion.find(13).update(assessment_sub_section_id: 2  ,	display_order:15)
		AssessmentQuestion.find(14).update(assessment_sub_section_id: 2  ,	display_order:16)
		AssessmentQuestion.find(15).update(assessment_sub_section_id: 2  ,	display_order:17)
		AssessmentQuestion.find(16).update(assessment_sub_section_id: 2  ,	display_order:18)
		AssessmentQuestion.find(89).update(assessment_sub_section_id: 2  ,	display_order:19)
		AssessmentQuestion.find(495).update(assessment_sub_section_id: 2  ,	display_order:20)
  end
end
