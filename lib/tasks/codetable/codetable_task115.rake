namespace :populate_codetable115 do
	desc "Additional Actions and Services"
	task :more_action_service => :environment do

		# Action
		CodetableItem.create(code_table_id:181,short_description:"Participate in job search - self",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Participate in unsubsidized employment",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Participate in High School/GED Certificate Program",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:181,short_description:"Referral for learning needs",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Enroll child(ren) in child care",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:181,short_description:"Enroll child(ren) in special needs child care",long_description:"",system_defined:"FALSE",active:"TRUE")

		# Service
		CodetableItem.create(code_table_id:182,short_description:"Participate in Bachelor's Degree Program",long_description:"Bachelor's Degree Program",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Participate in subsidized public employment",long_description:"Subsidised public employment",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Participate in subsidized private employment",long_description:"Subsidised private employment",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Participate in  Vocational Rehabilitation",long_description:"Vocational Rehabilitation",system_defined:"FALSE",active:"TRUE")

		# Supportive Service
		CodetableItem.create(code_table_id:168,short_description:"Provide bus pass",long_description:"Provide bus pass",system_defined:"FALSE",active:"TRUE")


		# Service
		CodetableItem.create(code_table_id:182,short_description:"Participate in Two-year Degree Program",long_description:"Two-year Degree Program",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Participate in Advanced Degree Program",long_description:"Advanced Degree Program",system_defined:"FALSE",active:"TRUE")

		# action
		CodetableItem.create(code_table_id:181,short_description:"Provide Child Care Services for Participant Enrolled in Community Service",long_description:"",system_defined:"FALSE",active:"TRUE")



	end
end
