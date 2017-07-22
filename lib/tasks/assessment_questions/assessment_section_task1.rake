namespace :assessment_section_task1 do
	desc "Assessment Sections"
	task :assessment_section => :environment do
		 connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.assessment_sections")
    	connection.execute("SELECT setval('public.assessment_sections_id_seq', 1, true)")

		AssessmentSection.create(title:"Employment",description:"Employment information about the customer",display_order:2,enabled:1,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Education",description:"Education information about the customer",display_order:	3	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Housing",description:"Housing information about the customer	",display_order:	4	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Pregnancy",description:"Pregnancy",display_order:	10	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Child Care and Parenting",description:"Child Care and Parenting	",display_order:	11	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Final Thoughts",description:"Additional insight	",display_order:	13	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"General Health",description:"General Health",display_order:	6	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Substance Abuse",description:"Substance Abuse",display_order:	8	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Mental Health",description:"Mental Health",display_order:	7	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Domestic Violence - Safety",description:"Domestic Violence - Safety",display_order:	9	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Additional Resources",description:"Additional Resources	",display_order:	14	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Transportation",description:"Transportation information about the customer",display_order:	5	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Relationships",description:"Relationships information about the customer",display_order:	12	,enabled:	1	,created_by: 1,updated_by: 1)
		AssessmentSection.create(title:"Demographics",description:"Demographics -Finance information about the customer",display_order:	12	,enabled:	1	,created_by: 1,updated_by: 1)


    end
end