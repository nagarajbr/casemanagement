namespace :populate_codetable315 do
	desc "Adding action types on program unit deny or closure"
	task :adding_action_types_on_program_unit_deny_or_closure => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Close all Representatives",long_description:"Close all Representatives",system_defined:"FALSE",active:"TRUE")
	end
end