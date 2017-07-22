namespace :recommendation_data_population_task do
	desc "Recommendations List"
	task :populate_recommendations => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.recommendations")
    	connection.execute("SELECT setval('public.recommendations_id_seq', 1, true)")

		 Recommendation.create(recommendation_text:"Participant will be enrolled in either the Nurturing Fathers Parenting Class or the Domestic Violence Batterer Intervention Class. Encourage participant to miss no more than 3 class sessions in order to receive a certificate of completion. Regularly revi...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Encourage participant to enroll in the Financial Management Workshop to assist their understanding of savings, debt, budgeting, credit scores, and other topics.Regularly review incentives and benefits of financial management workshop with participant. ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Refer participant to community agencies,provided bus passes,given additional job leads, or provided other services as needed food banks, child care, Dress for Success.Obtain signature on release of information form for each agency. Weekly follow-up w...",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Participant will be provided job readiness training, application and resume assistance, and job leads. Bus Passes and interview suiting will be provided for job interviews. Participant will make 3 job calls weekly to obtain interviews and/or employment.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Participate in Job Search or on-the-Job Training Placement or Work Experience Placement or Bachelor&#39;s Degree Program or subsidized public employment or subsidized private employment or Two-year Degree Program or  Advanced Degree Program or Career and Technical Education or Attend Job Readiness Workshop.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Obtain copy of record. </br>Obtain parole or probation officer's court case, contact information, as applicable.	 ",comments: "	",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Possible excused absences for scheduled appointments.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Gain work experience through Career and Technical training.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral to Vocational Rehabilitation for further evaluation	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Participate in ESL program or Vocational Rehabilitation.",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral to a local housing agency, family preservation, or shelter resources.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Provide monthly transportation stipend, transit/bus passes or tokens, and gas cards as appropriate.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral to local Health Department (DHEC) or Free Clinic.</br></br>If participant does not have Medicaid or health insurance, make a referral to local Medicaid office.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Provide participant with forms to substantiate medical condition. </br></br>If participant does not have Medicaid or health insurance, make a referral to local Medicaid Office.</br></br>If medical condition has lasted 12 or more months, refer participant...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral for a medical checkup. TANF funds cannot be used to pay for service.</br></br>Provide participant with the forms to substantiate medical condition, DSS Form 1247.</br></br>If participant does not have Medicaid or health insurance, make a...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Provide the participant with referrals to DHEC for vaccinations.</br></br>If participant does not have Medicaid or health insurance, make a referral to the local Medicaid Office.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Provide participant with Physician's Statement to verify pregnancy and expected due date.</br></br>Offer a referral to Children's health program and WIC as appropriate</br></br>If participant does not have Medicaid or health insurance, make a referral to...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Refer participant to family services, Mental Health Specialist or Vocational Rehabilitation.</br></br>If participant does not have Medicaid, refer to local Medicaid office.</br></br>Provide the participant with Physician's Statement.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"If participant indicated a mental health issue and is receiving treatment, provide participant with a physician's statement.</br></br>If participant indicated a mental health issue and is not receiving treatment, offer a referral to mental health special...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Refer participant to local DAODAS for further in-depth screening and assessment.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral to family services, a mental health specialist, or a domestic violence specialist.TANF funds can be used to pay for medical forms, but cannot be used to pay for medical exams</br></br>May offer temporary domestic violence exemp...	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral to family services, a mental health specialist, a domestic violence specialist or Public Safety Official that can address the safety concern.</br></br>Provide information or telephone numbers for places that can help.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral and/or provide participant with physician's statement	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"The participant indicates that they are<br />providing care giving services for an elderly,<br />disabled, or sick family member.	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Offer a referral for childcare.</br></br>Request participant to complete/update a childcare plan, including backup providers	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Obtain copy of court order (if available) and scan into SCOSA. Notify EW of change</p>	 ",comments: "",created_by: 1,updated_by: 1)
		 Recommendation.create(recommendation_text:"Enroll in Marriage & Parenting (MA & PA) Class for healthy relationships and co-parenting skills training. Attend Attorney Workshop for assistance with visitation, custody, or modification orders. Weekly follow-up, chart notes, and monthly status reports.	 ",comments: "",created_by: 1,updated_by: 1)


	end
end