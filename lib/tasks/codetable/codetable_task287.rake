namespace :populate_codetable287 do
desc "adding_school_attendance_type"
task :adding_school_attendance_type => :environment do
	codetableitems = CodetableItem.create(code_table_id:22,short_description:"None",long_description:"None",system_defined:"FALSE",active:"TRUE")
	end
end
