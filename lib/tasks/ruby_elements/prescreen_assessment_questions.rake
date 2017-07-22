namespace :prescreen_assessment_questions do
	desc "Assessment Employment Job Opportunity"
	task :prescreen_assessment_questions => :environment do

		# 1.
		assessment_section_object = AssessmentSection.create(title:"Prescreening",description:"Prescreening -household circumstances questions",display_order:	13	,enabled:	1	,created_by: 1,updated_by: 1)
		# 2.
		assessment_sub_section_object = AssessmentSubSection.create(assessment_section_id:	assessment_section_object.id	,title:"Household Circumstances",description:"PreScreening Household Circumstances ",display_order:	1,enabled:1,all_sub_section_order:	1	,created_by: 1,updated_by: 1)
# ****************************************************
# Q1
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Are you currently working?",question_text:"Are you currently working?",display_order:10,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)
# ****************************************************
		# Q2
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Why do you think you are not currently working?",question_text:"Why do you think you are not currently working?",display_order:20,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"LABEL",prompt_style_class: "fi-alert",created_by: 1,updated_by: 1)



# ****************************************************
		# Q3
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Employer Initiated",question_text:"Employer Initiated",display_order:30,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Laid off due to company downsizing or poor company performance",val:"Laid off due to company downsizing or poor company performance",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Did not pass drug test",val:"Did not pass drug test",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Criminal record",val:"Criminal record",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q4
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Job Opportunity",question_text:"Job Opportunity",display_order:35,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No jobs available",val:"No jobs available",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Jobs were outsourced",val:"Jobs were outsourced",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Company closure",val:"Company closure",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q5
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Satisfaction / Motivation",question_text:"Satisfaction / Motivation",display_order:50,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Did not like the work involved",val:"Did not like the work involved",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Do not want to work",val:"Do not want to work",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Schedule/shift issue",val:"Schedule/shift issue",display_order: 30,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Too busy to work",val:"Too busy to work",display_order: 40,created_by: 1,updated_by: 1)

# ****************************************************
		# Q6
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Compensation",question_text:"Compensation",display_order:60,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Low wages/hours",val:"Low wages/hours",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No benefits",val:"No benefits",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Poor benefits",val:"Poor benefits",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q7
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Work Site Behavior",question_text:"Work Site Behavior",display_order:70,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Insubordination",val:"Insubordination",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Interpersonal conflicts",val:"Interpersonal conflicts",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Tardiness/Absence",val:"Tardiness/Absence",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q8
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Experience / Skills",question_text:"Experience / Skills",display_order:80,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Inadequate education, experience, or skills",val:"Inadequate education, experience, or skills",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Language barrier",val:"Language barrier",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Returned to school",val:"Returned to school",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q9
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Health",question_text:"Health",display_order:90,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Physical health",val:"Physical health",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Mental health/stress",val:"Mental health/stress",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Pregnancy",val:"Pregnancy",display_order: 30,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Alcohol/drugs",val:"Alcohol/drugs",display_order: 40,created_by: 1,updated_by: 1)

# ****************************************************
		# Q10
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Household",question_text:"Household",display_order:100,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Issue with child",val:"Issue with child",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Issue with household member",val:"Issue with household member",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Need to work close to home",val:"Need to work close to home",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q11
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Childcare",question_text:"Childcare",display_order:110,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Can not find childcare",val:"Can not find childcare",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Location of available child care",val:"Location of available child care",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Can not afford",val:"Can not afford",display_order: 30,created_by: 1,updated_by: 1)

# ****************************************************
		# Q12
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Other",question_text:"Other",display_order:130,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"LABEL",created_by: 1,updated_by: 1)

# ****************************************************
		# Q13
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Unemployed for over a year",question_text:"Unemployed for over a year",display_order:140,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOX",created_by: 1,updated_by: 1)

# ****************************************************
		# Q14
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Notes",question_text:"Notes",display_order:150,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"TEXTAREA",created_by: 1,updated_by: 1)

# ****************************************************
		# Q15
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Job Type",question_text:"Job Type",display_order:160,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIOGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Full Time",val:"Full Time",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Part Time",val:"Part Time",display_order: 20,created_by: 1,updated_by: 1)

# ****************************************************
		# Q16
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Does the job offer Health Insurance benefits to cover you and your immediate family?",question_text:"Does the job offer Health Insurance benefits to cover you and your immediate family?",display_order:170,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 20,created_by: 1,updated_by: 1)

# ****************************************************
		# Q17
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:assessment_sub_section_object.id,title:"Does the job help you become self-sufficient?",question_text:"Does the job help you become self-sufficient?",display_order:180,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"RADIO",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Yes",val:"Y",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No",val:"N",display_order: 20,created_by: 1,updated_by: 1)


	end
end