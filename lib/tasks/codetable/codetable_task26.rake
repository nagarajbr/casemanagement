# Author : Manoj Patil
#  Date : 09/15/2014
namespace :populate_codetable26 do
	desc "Application Disposition Status list"
	task :budget_relationship_cleanup => :environment do
		CodetableItem.where("code_table_id = 125 and id = 5946 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5950 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5955 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5960 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5961 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5963 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5967 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5970 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5979 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5983 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5986 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5987 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5989 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5994 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5995 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 5999 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6005 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6007 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6001 ").destroy_all
		CodetableItem.where("code_table_id = 125 and id = 6004 ").destroy_all

	end
end