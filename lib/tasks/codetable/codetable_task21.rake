namespace :delete_duplicate_codetable_items do
	desc "delete_duplicate_codetable_items"
	task :delete_duplicate => :environment do
		CodetableItem.where("id = 5880 and code_table_id = 24").destroy_all
		CodetableItem.where("id = 5871 and code_table_id = 86").destroy_all
		CodetableItem.where("id = 5905 and code_table_id = 43").destroy_all
		CodetableItem.where("id = 5884 and code_table_id = 26").destroy_all
		CodetableItem.where("id = 5896 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5886 and code_table_id = 32").destroy_all
		CodetableItem.where("id = 5897 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5855 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5858 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5865 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5909 and code_table_id = 63").destroy_all
		CodetableItem.where("id = 5918 and code_table_id = 72").destroy_all
		CodetableItem.where("id = 5910 and code_table_id = 63").destroy_all
		CodetableItem.where("id = 5889 and code_table_id = 35").destroy_all
		CodetableItem.where("id = 5854 and code_table_id = 81").destroy_all
		CodetableItem.where("id = 5890 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5882 and code_table_id = 25").destroy_all
		CodetableItem.where("id = 5883 and code_table_id = 25").destroy_all
		CodetableItem.where("id = 5893 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5874 and code_table_id = 86").destroy_all
		CodetableItem.where("id = 5891 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5892 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5899 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5863 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5900 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5864 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5901 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5857 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5859 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5856 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5861 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5860 and code_table_id = 14").destroy_all
		CodetableItem.where("id = 5887 and code_table_id = 34").destroy_all
		CodetableItem.where("id = 5906 and code_table_id = 43").destroy_all
		CodetableItem.where("id = 5903 and code_table_id = 36").destroy_all
		CodetableItem.where("id = 5908 and code_table_id = 56").destroy_all
		CodetableItem.where("id = 1939 and code_table_id = 13").destroy_all
		CodetableItem.where("id = 5867 and code_table_id = 83").destroy_all
	end
end