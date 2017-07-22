namespace :populate_codetable4 do
	desc "Client Characteristics"
	task :client_characteristics => :environment do
code_tables = CodeTable.create(name:"Other Characteristics",description:"Other Characteristics")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:" ",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Alien-Qualified/40 QTRS",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"ARKids A Eligible",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Domestic Abuse",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Emancipated Minor",long_description:"Emancipated Minor by parental agreement or law",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Employmt - Unemployed",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Family Cap Child",long_description:"Child born while mother receiving TEA Grant",system_defined:"TRUE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Felony Drug Convicti",long_description:" Felony Drug Conviction after July 1, 1997",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Fleeing Felon",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Foster Child",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Fraud - IPV Conviction1",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"FS-Former Member Medical",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Gang Activity",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Immunized",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Incarcerated",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Ineligible Student",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Institutionalized",long_description:"Used to determine correct ategory",system_defined:"TRUE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Interpretor Required",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSA-due to SGA",long_description:"lost SSA due to Substantial Gainful Activity",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-on/after 7-1-97",long_description:" Welfare Reform changing Child Disability Determi ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-Reduction Factor",long_description:"Lost SSI in/after 1984 Reduction Factor eliminated",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-SSA Adult Child",long_description:"Lost SSI on/after 7/1/87 SSA Disabled Adult Child",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-SSA COLA Increas",long_description:"Lost SSI after 4/77 due to SSA COLA increase ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-SSA Divorce Spou",long_description:"Lost SSI due to SSA disabld survivng divorcd spou ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-SSAWidow/Widower",long_description:"Lost SSI due to entitlement to SSA Widow/Widowers ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medicare A-Curent Covered",long_description:"Currently receiving MedicarePart A",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medicare A-Lost SGA",long_description:"Lost Medicare A  due to Substanial Ganiful Activit",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medicare A-Reenrolled",long_description:"Lost Medicare A due  SGA entitle to & re-enrolled",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medicare A&B-Curent Cover",long_description:"Currently receiving Mediare Part A & B",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medicare B-Curent Covered",long_description:"Currently receiving Medicare Part B",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Minor Parent",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Nonqualify Alien Preg Wom",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Not ARKidsA-AR  State Emp",long_description:"Not ARKids A eligible, child of AR State Employee",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Not ARKidsA-not AR State",long_description:"Not ARKids A eligible, not child of AR State Emplo",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Parole Violator",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Pickle",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Prmary Wage Earner",long_description:"Parent earning greater amount of income in 24 mos.",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Probation Violator",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SSI Applied for benefits",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SSI Recipient",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SSI Suspended",long_description:"SSI Suspended used for FS Categorical Eligibility",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Suspended",long_description:"TEA Suspended used for FS Categorical Eligibility",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Active Duty",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Battered Spouse/Child",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled Veteran",long_description:"Veteran Characteristics",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"HD-not for alien status",long_description:"Honarably Discharged not based on alient status",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Honorably Discharged",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Korean War",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Persian Gulf War",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Spouse/Child Disabled Vet",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Spouse/Child-Honor Dischr",long_description:"Spouse/Child of a honorable discharged Veteran",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Surviving Spouse/Child",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vietnam Veteran",long_description:"Veteran Characteristics",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"WW II Veteran",long_description:"Veteran Characteristics",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"WWI Veteran",long_description:"Veteran Characteristics",system_defined:"FALSE",active:"TRUE")

code_tables = CodeTable.create(name:"Work Characteristics",description:"Work Characteristics")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:" ",long_description:"Blank",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"60 yrs or older",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled 2nd Prnt TL Ext",long_description:"Medically Incapacitated 2nd Parent",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled Fed TL Ext",long_description:"Impairment too severe ARS denied SSA/SSI appealed",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled Long-Term TL EXT",long_description:"Deferred medically incapacitated",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Extended Fair Hearing",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Incapacitated Long Term",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Incapacitated Short Term",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Required to work",long_description:"Mandatory - TEA",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Participate  ARS workshop",long_description:"Participating in ARS sheltered workshop",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Pending Admin Hearing",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA 2 Parent Child Care",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA 2nd Parent Ill Child",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA 2nd Parent Mandatory",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Child 3-12 mo/no cc",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Child is not 3 mo old",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer 3rd Trimester",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Caretaker",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Child Care",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Domestic Viole",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Extra Circumsta",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Rehab Disabilit",long_description:"TEA deferred referred to Rehab for Disability Dete",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Support Serv",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Defer Transportation",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Exempt from Time Limi",long_description:"TEA Exempt from time limit",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd 2 Par no Fed CC",long_description:"Two parent family not receiving Fed child care",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd 3rd Trimstr Prg",long_description:"Deferred woman in 3rd trimester of pregnancy",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd 60 yrs or older",long_description:"Deferred adult age 60 or over",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Cares for Ill",long_description:"Deferred needed in home to care for seriously ill",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Case Circumstan",long_description:"Extension based on case circumstances",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Ch<3mo or no CC",long_description:"Child under 3 mo or under 12 mo without child care",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Child Care Unav",long_description:"Deferred child care not available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Domestic Violen",long_description:"Deferred victim of domestic violence",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Educ/Training",long_description:"Extension due to education or training",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Extraord Circum",long_description:"Deferred extraordinary circumstances",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd No Support Svcs",long_description:"Deferred supportive services not available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd No Transportati",long_description:"Deferred transportation services not available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Par 2 reqd home",long_description:"2nd prnt needed in home care 4 severely disabld ch",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Rehab Svcs",long_description:"Deferred referred to Rehab Svcs for Disable Assmt",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Extnd Unable find job",long_description:"Participate satisfac unable find job beyond contro",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA LT 2nd Prnt",long_description:"Medically incapacitated 2nd parent",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Minor Parent BU Head",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Minor Parent School",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Rehab-Education Track",long_description:"mandatory accepted Rehab Services Education Track",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Rehab-Employment Trac",long_description:"mandatory accepted Rehab employment track",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA SSA Denial Appeal Pen",long_description:"",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Under Age 18 yrs",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol 2 Par Disabl Chld",long_description:"TEA Volunteer 2nd Parent Care for Disabled Child",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol 2 Prnt Care Child",long_description:"TEA Volunteer 2nd Par Home Defer to Care for Child",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Age 60 or older",long_description:"TEA Volunteer Age 60 or Older",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Chld Care Not Avl",long_description:"TEA Volunteer Child Care Not Available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Domestic Violence",long_description:"TEA Volunteer Victim of Domestic Violence",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Extra Circumstanc",long_description:"TEA Volunteer Extraordinary Circumstances",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Needed in Home",long_description:"TEA Volunteer Needed in Home",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Pregnant Woman",long_description:"TEA Volunteer Pregnant Woman",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Rehab Refer Disab",long_description:"TEA Volunteer Adult Refer to Rehab for Disability",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Supp Svs Not Avai",long_description:"TEA Volunteer Supportive Services Not Available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Vol Transp Not Avail",long_description:"TEA Volunteer Transportation Not Available",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Welfare to Work",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Work Activity Sanctio",long_description:"TEA Sanctioned for Work Activity Non-compliance",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Treatment severe barriers",long_description:"receiving treatment through sever bariers program",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Unable part byond control",long_description:"Unable participt work active circum byond control",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Victim Domestic Violence",long_description:"Victim of Domestic Violence",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vol disabled 2nd Parent",long_description:"TEA Volunteer 2nd Parent Medically Incapacitated",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vol Disabled Long Term",long_description:"",system_defined:"FALSE",active:"TRUE")
code_tables = CodeTable.create(name:"Disability Characteristics",description:"Disability Characteristics")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:" ",long_description:"Disability",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"A&A-Surviving Spouse",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"A&A-Veteran ",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Blind",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Developmental",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disability-Unverified",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disability-Verified",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled - SSI",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled - Veteran 100%",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled - Veteran Rated",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled - Worker'sComp",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled -SSA",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled-MRT",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled-Obvious",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled-Other Government",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled-Railroad Retirme",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Disabled-State Supplement",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Hearing Impaired",long_description:"Disability",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-on/after 7-1-97",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Lost SSI-within 12 mos",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mental",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mobility",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Paraplegic",long_description:"Disability",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Receipt of Rehab Services",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Speech Impaired",long_description:"Disability",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"VA Title 38-Spouse/Child",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Visually Impaired",long_description:"Disability",system_defined:"FALSE",active:"TRUE")
code_tables = CodeTable.create(name:"Health Characteristics",description:"Health Characteristics")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:" ",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Alcohol",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Amphetamines",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Barbiturates/Tranquilizer",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Cocaine/Crack",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Codeine",long_description:" ",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inhalants",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Marijuana",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"PCP/Halucinogens",long_description:"Substance Abuse",system_defined:"FALSE",active:"TRUE")
	end

end




