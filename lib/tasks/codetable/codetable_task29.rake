# Author : Manoj Patil
#  Date 09/17/2014
namespace :populate_codetable29 do
	desc "Application Origin cleanup"
	task :application_origin_cleanup => :environment do

		# registered status is deleted
		CodetableItem.where("code_table_id = 98 ").destroy_all
		# Add data
		CodetableItem.create(code_table_id:98,short_description:"DWS-Local Office",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:98,short_description:"DWS-Other",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:98,short_description:"DHS-Systems",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:98,short_description:"DHS-County",long_description:"",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:98,short_description:"Other Partners",long_description:"",system_defined:"TRUE",active:"TRUE")
	end
end