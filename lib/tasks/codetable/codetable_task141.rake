namespace :populate_codetable141 do
	desc "delete duplicate activities"
	task :delete_duplicate_activities => :environment do
# 6355;181;"Provide Child Care Services for Participant Enrolled in Community Service"
# 6283;181;"Submit Attendance record";"";f;"2015-05-04 18:03:59.024272";"2015-05-04 18:03:59.024272";t;"";;""

		CodetableItem.where("code_table_id = 181 and id in (6355,6356)").destroy_all



    end
end