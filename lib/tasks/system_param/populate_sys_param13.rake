namespace :populate_sys_param13 do
	desc "Web Server Name"
	task :system_param_host_name => :environment do

		SystemParam.create(system_param_categories_id: 9, key:"WEB_SERVER_NAME", value:"localhost:3000",description:"Web Server Name - Used in mailer",created_by: 1,updated_by: 1)
	end

end