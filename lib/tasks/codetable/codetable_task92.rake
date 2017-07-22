namespace :populate_codetable92 do
	desc "Provider Services"
	task :provider_services => :environment do
		code_tables = CodeTable.create(name:"Supportive Services",description:"Provider Services")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Books/Educational Supplies",long_description:"Provide Books/Educational Supplies",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Employer Required Screening",long_description:"Provide Employer Required Screening Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Tuition/Education Fees ",long_description:"Provide Tuition/Education Fees Service ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Fees, licenses, Etc",long_description:"Provide fees, licenses, etc",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Job Search Activities ",long_description:"Provide Job Search Placement Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Medical Expenses only for items not covered by Medicaid",long_description:"Provide Medical Expenses only for items not covered by Medicaid",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Other Commodity",long_description:"Provide Other Commodity",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Other Services",long_description:"Provide Other Services",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Rent Including deposits",long_description:"Provide Rent Including deposits Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"RT",long_description:"Provide RT",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"State Funds",long_description:"State Funds",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Transportation, Paid to Client ",long_description:"Provide Transportation, Paid to Client ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Transportation, Paid to Provider ",long_description:"Provide Transportation, Paid to Provider ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Uniforms, Shoes, Clothing Purchase ",long_description:"Provide Uniforms, Shoes, Clothing Purchase",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Uniform/Clothing Repair/Alteration, Etc",long_description:"Provide uniform / clothing repair / alteration, etc",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vehicle Insurance ",long_description:"Provide Vehicle Insurance Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vehicle Repairs ",long_description:"Provide Vehicle Repairs service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vehicle Down Payment ",long_description:"Provide Vehicle Down Payment",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Vehicle Tax/License ",long_description:"Provide Vehicle Tax/License",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Wage subsidy paid to employer",long_description:"Provide Wage subsidy paid to employer",system_defined:"FALSE",active:"TRUE")

    end
end