# Author : Vishal Deep
#  Date 06/18/2015
namespace :populate_codetable164 do
	desc "Added new Denial Reasons - ACES - Non Rule Related "
	task :added_denia_reasons_aces => :environment do
		# Add data
		CodetableItem.create(code_table_id:66,short_description:"AAPD-No Slots",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"AAPD-Not 21-64 yrs",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"AAPD-Not Disabled",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"AAPD-Not SSI",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Age requirement",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"Alien in country 8 months",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Deprivation Not Met",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Able to transfer/eat",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Able to transfer/toile",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Cost Effectiveness",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"EC-Mental Illness",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Mental Retardation",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Skilled Care",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"EC-Transfer/toilet/eat",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Eligible for SSI",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"Employed 100 hours plus",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Family Planning-Male",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Family Planning-Pregnant",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Family Planning-Sterile",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Health Insurance ARKids",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"Income exceeds 185%",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Income- Excess Earned",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Income -Excess Other",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Institutional Status Not ",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Medical Necessity not met",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"MRT- Prior Work< 1 year",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-AFDC-MN no incapacity",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-Employed",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-Medical Evid/noshow",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-No Severe Impairment",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"MRT-Other work < 1 year",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-TEFRA employed",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-TEFRA NoSevereImpair",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"MRT-TEFRA NoSevereLimit",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"No Child in home",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"No Medicare",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Not Categorically Eligibl",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Not Citizenship/Legal Ali",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Not LTC-Personal Care Med",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Not LTC-Personal Care Not",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"Not Resident",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Quarters of Work",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Relationship not met",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Resources- Transfer",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Resources-Bank account",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"Resources-Other",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Resources-Real property",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"Striker Provision",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"TEA Job Activity",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"TEA Receive 60 mo benefit",long_description:"",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:66,short_description:"TEA-Adult Supervised situ",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"TEA-Became Employed",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"TEA-Diversion Assistance",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:66,short_description:"TEA-PRA",long_description:"",system_defined:"TRUE",active:"TRUE")
	end
end