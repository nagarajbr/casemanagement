namespace :access_rights_for_intake_worker do
	desc "Creating access rights for system support user"
	task :create_access_rights_intake_worker => :environment do
		user_role_id = 3
		connection = ActiveRecord::Base.connection()
		delete_script = "DELETE FROM access_rights where role_id = " + user_role_id.to_s
		connection.execute(delete_script)
		AccessRight.create(role_id: user_role_id, ruby_element_id: 1,    access:'N', created_at: Time.now, updated_at: Time.now)   # "Pre-screening"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 2,    access:'N', created_at: Time.now, updated_at: Time.now)   # "Initial Survey"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 3,    access:'N', created_at: Time.now, updated_at: Time.now)   # "Pre Screen"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 4,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Master Client Data Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 5,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Profile"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 6,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Demographics"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 7,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Race"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 8,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Citizenship"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 9,    access:'Y', created_at: Time.now, updated_at: Time.now)   # "Contact"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 10,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Address"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 11,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Relationship"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 12,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Characteristics"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 13,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Disability"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 14,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Health"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 15,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Work Participation"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 16,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Other"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 17,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Medical"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 18,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Pregnancy"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 19,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Disability"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 20,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Immunization"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 21,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Income"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 22,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Income"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 23,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Income Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 24,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Expense"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 25,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Expense"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 26,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Expense Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 27,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Resource"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 28,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Resource"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 29,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Resource Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 30,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Education"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 31,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Education"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 32,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Education Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 33,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employment"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 34,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employment"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 35,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employment Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 36,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Sanctions"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 37,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Sanctions"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 38,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Activities"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 39,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Activities"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 40,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Program Participation"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 41,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Program Participation"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 42,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Out of state payments"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 43,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Payment History"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 44,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Parental Responsibility"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 45,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Parental Responsibility"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 46,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Barriers"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 47,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Barriers"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 48,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Skills"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 49,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Skills"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 50,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Scores"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 51,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Scores"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 52,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Application Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 53,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Applications"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 54,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Application"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 55,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Intake"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 56,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Intake"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 57,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Application Members"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 58,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Application Relationships"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 59,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Processing"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 60,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Application Screening"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 61,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Data Verification"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 62,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Document Verification"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 63,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Screening Results"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 64,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Program Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 65,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Program Units"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 210,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Program Units"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 66,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Validate Program Unit"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 67,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Validate Program Unit"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 68,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Data Verification"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 69,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Document Verification"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 70,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Screening Results"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 71,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Check Eligibility"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 72,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Eligibility Determiniation"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 73,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Submit"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 74,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Summary"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 75,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Representatives"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 76,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Representatives"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 77,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Payments"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 78,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Payment History"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 79,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Issue Payments"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 80,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Actions"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 81,   access:'Y', created_at: Time.now, updated_at: Time.now)   # "Actions"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 82,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Work Readiness Assessments"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 83,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Education"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 84,   access:'N', created_at: Time.now, updated_at: Time.now)   # "English"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 85,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Highest Grade/Degree"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 86,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Other Education"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 87,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Learning Difficulties"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 88,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Employment"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 89,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Currently Working"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 90,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Reasons Not Working"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 91,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Job History"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 92,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Legal Barriers"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 93,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Experience"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 94,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Spoken Languages"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 95,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Work Interests"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 96,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Career Interests"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 97,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Finance"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 98,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Financial Issues"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 99,   access:'N', created_at: Time.now, updated_at: Time.now)   # "Benefits Received"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 100,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Housing"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 101,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Current Housing"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 102,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Housing Situation"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 103,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Transportation"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 104,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Transportation Method"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 105,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Driving Licence"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 106,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Transportation Challenge"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 107,  access:'N', created_at: Time.now, updated_at: Time.now)   # "General Health"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 108,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Current Health"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 109,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Health Challenge"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 110,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Mental Health"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 111,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Mental Health"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 112,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Diagnosis"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 113,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Substance Abuse"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 114,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Alcohol and Drugs"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 115,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Household Drugs"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 116,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Domestic Violence - Safety"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 117,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Victim"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 118,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Perpetrator"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 119,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Pregnancy"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 120,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Pregnancy"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 121,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Child Care and Parenting"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 122,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Children Issues"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 123,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Primary Caregiver"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 124,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Parenting and Child Support"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 125,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Childcare"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 126,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Childcare Status"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 127,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Backup Childcare Plan"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 128,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Relationship Status"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 129,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Relationship Status"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 130,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Final Thought"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 131,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Closing Question"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 132,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Assessments"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 133,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Assessment Worksheet"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 134,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Assessment History"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 135,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Workload Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 136,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "My To Do List"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 137,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "To Do List"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 138,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Workload Queues"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 139,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Intake Queues"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 140,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Workload Queues"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 141,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Supervisor Workspace"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 142,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Supervisor Workspace"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 143,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Interviews Management"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 144,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Interviews Management"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 145,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Employment Readiness Plan"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 146,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Select Program Unit"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 147,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Select Program Unit"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 148,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Employment Plan"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 149,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Employment Plan"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 150,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Barrier Reduction Plan"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 151,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Barrier Reduction Plan"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 152,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Authorization"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 153,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Authorization"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 206,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Career Pathway Plan"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 207,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Career Pathway Plan"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 208,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Aprroval"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 209,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Aprroval"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 154,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Master Payment Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 155,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Provider"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 159,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Provider"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 156,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Payments Entry"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 157,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Review Payments"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 160,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Payments Authorization"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 158,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Review Warrants"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 161,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Master Employer Data Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 162,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Employer"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 163,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Employer"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 164,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employer Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 165,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employer Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 166,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employer Address"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 167,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Employer Contacts"

	#   AccessRight.create(role_id: user_role_id, ruby_element_id: 168,  access:'N', created_at: Time.now, updated_at: Time.now)   #
	#   AccessRight.create(role_id: user_role_id, ruby_element_id: 169,  access:'N', created_at: Time.now, updated_at: Time.now)   #

		AccessRight.create(role_id: user_role_id, ruby_element_id: 170,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Master Provider Data Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 171,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Provider"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 172,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search Provider"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 173,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 174,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 175,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Address"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 176,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Language"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 177,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Services"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 178,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Provider Contacts"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 179,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Agreements"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 180,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Agreement"

	#   AccessRight.create(role_id: user_role_id, ruby_element_id: 181,  access:'N', created_at: Time.now, updated_at: Time.now)   #

		AccessRight.create(role_id: user_role_id, ruby_element_id: 182,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Master Education Data Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 183,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 184,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Search"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 185,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "School Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 186,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "School Details"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 187,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "School Address"
	#   AccessRight.create(role_id: user_role_id, ruby_element_id: 188,  access:'N', created_at: Time.now, updated_at: Time.now)   #
				AccessRight.create(role_id: user_role_id, ruby_element_id: 189,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "School Contacts"

		AccessRight.create(role_id: user_role_id, ruby_element_id: 190,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Utilities Management"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 191,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Application Users"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 192,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Profile"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 193,  access:'N', created_at: Time.now, updated_at: Time.now)   # "New"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 194,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Edit"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 195,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Reset Password"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 196,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System Unlock"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 204,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System lock"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 198,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System Parameters"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 199,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System Parameters"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 200,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Lookup code values"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 201,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Lookup code values"
			AccessRight.create(role_id: user_role_id, ruby_element_id: 202,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Programs"
				AccessRight.create(role_id: user_role_id, ruby_element_id: 203,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Service Programs"

		# AccessRight.create(role_id: user_role_id, ruby_element_id: 197,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System Unlock"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 205,  access:'N', created_at: Time.now, updated_at: Time.now)   # "System lock"

	end
end