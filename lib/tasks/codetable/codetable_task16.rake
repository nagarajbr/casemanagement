namespace :populate_codetable16 do
	desc "add_missing_code_items"
	task :add_missing_code_items => :environment do

		code_tables = CodeTable.where("id = 13").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"External Team",long_description:" ",system_defined:"FALSE",active:"TRUE")
	    code_tables = CodeTable.where("id = 81").first
	    codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medically Needy Resource ",long_description:"Medically Needy Resource",system_defined:"FALSE",active:"TRUE")
	    code_tables = CodeTable.where("id = 14").first
	    codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"First Cousin  ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Step Sibling's Spouse ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Step Grandparent ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Great Grandparent ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Step Great Grandparent ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Stp Gr Gr Grdprnt's Spou ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Stp Gr Gr Gr Grdpt's Spo ",long_description:"Step Great Great Grandparent's Spouse",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Caregiver",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Second Cousin ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Spouse - Common Law ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Half Sibling ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 82").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Treasury Offset Program",long_description:"",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 83").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"WP/On the Job Training ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"IRS Match",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 84").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inactive Partial",long_description:"",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inactive Full",long_description:" ",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.where("id = 86").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"APPROVED FIXED-EXISTING ",long_description:"Approved for fixed elgibility of existing case.",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"CLOSE TEA AND OPEN TM CA",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"MEDICAID REMAINS OPEN",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"REINSTATE CLOSED CASE TO ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TRANFER AND INCREASE GRA",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SYSTEM GERERATED INCREAS",long_description:" ",system_defined:"FALSE",active:"TRUE")

		code_tables = CodeTable.where("id = 18").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Duplicate Participation",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SSN-Mismatch",long_description:" ",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.where("id = 97").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Restored - Math Rrror",long_description:"Restoration - Arithmetic Error",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 24").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"2 Year College or Tech ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 25").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Moved",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Quit-Labor Organization ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Quit-School 1/2 time ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 26").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Banking ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 28").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Deemer",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 32").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Child Care - Elementary ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 34").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Trailer-Tractor/Trailer ",long_description:" ",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.where("id = 35").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Former FS Member Medical",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lodging-Medical Care ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 36").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Older American Title VII ",long_description:"Title VI of the Older American Act",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Rental-Non Land < 20 hrs ",long_description:"manged leass than 20 hours per week",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Rental-Non Land 20 hrs+  ",long_description:"Manged 20 or more hours a week.",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reimburs URA/RPA Act '70 ",long_description:"Uniform Relocation Assist & Real Property Acquisit",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Volnt Srvc Act'73-FS/TEA",long_description:"Ttl II&III Domstic Volnt Act  FS or TEA  at join",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vista Volunt Ttl I-FS/TEA",long_description:"Vista Volunteer Ttle I FS or TEA recipient at join",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Blood/Plasma Sales ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Deemed-Stepparent ",long_description:" ",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Deemed-Food Stamp Student",long_description:"Monies given to a BU member by a student BU member",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Retired Sr Volunteer  ",long_description:"Retired Seniro Volunteer Title II or III",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Serv Crp Retir Exc-Wages ",long_description:"Serv Crps of Rtrd Excutves Ttl II not as volunteer",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sr Hlth Aid Ttl II-Wages ",long_description:"Senior Health Aide Title II- not as volunteer",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Salary/Wages OJT/WIA",long_description:"Salary/Wages OJT/WIA",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Urban Crime Prev Title I ",long_description:"urban Crime Prevention Title I",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 40").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"NADA",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 43").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Assignment Compl on time ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Transportation - Other ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 10").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Bismark",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 56").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work Activity 2 or more ",long_description:"Work Activity Non-Compliance 2 or more times",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 63").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Indian Reserv-Required  ",long_description:"Vehicles driven required to have a license",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Intend to build and live ",long_description:"Intnention to build and live on the land",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.where("id = 66").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Earnings Excced FPL",long_description:"Earnings Excced FPL",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 67").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Drug/Alcohol Treatment Cn",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Emergency Payee",long_description:"Emergency Payee",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Guardian",long_description:"Guardian",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Legal Custodian",long_description:"Legal Custodian",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Protective Payee",long_description:"Protective Payee",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.where("id = 42").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Restored - Math Rrror",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 72").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Institutional Status Not ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 73").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TM form not returned",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work Activity Non-comply",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Progressive Sanction",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Close Reached 24 Mo",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"ARKids A Eligible",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Not ARKidsA-AR  State Emp",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Not ARKidsA-not AR State",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"ARxSenior Eligible",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Not ARxSenior Eligible",long_description:" ",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.where("id = 74").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Override",long_description:"Override",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Enumerated",long_description:"Enumerated",system_defined:"FALSE",active:"TRUE")

end

end