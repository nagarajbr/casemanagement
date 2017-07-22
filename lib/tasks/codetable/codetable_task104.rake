namespace :populate_codetable104 do
	desc "Provider Agreement Termination Reasons"
	task :provider_agreement_termination_reasons  => :environment do
		code_table = CodeTable.create(name:"Provider Agreement Termination Reasons",description:"Provider Agreement Termination Reasons ")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Provider Requested",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Agency Initiated",long_description:"",system_defined:"FALSE",active:"TRUE")

	end
end