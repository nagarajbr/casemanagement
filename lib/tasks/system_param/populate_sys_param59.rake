namespace :populate_sys_param59 do
	desc "notes types"
	task :notes_type_update => :environment do
		SystemParam.where("system_param_categories_id = 25 and key = '6471'").update_all("value = '01'")
		SystemParam.where("system_param_categories_id = 25 and key = '6472'").update_all("value = '02'")
		SystemParam.where("system_param_categories_id = 25 and key = '6473'").update_all("value = '03'")
		SystemParam.where("system_param_categories_id = 25 and key = '6039'").update_all("value = '04'")
		SystemParam.where("system_param_categories_id = 25 and key = '6474'").update_all("value = '05'")
		SystemParam.where("system_param_categories_id = 25 and key = '6475'").update_all("value = '06'")
		SystemParam.where("system_param_categories_id = 25 and key = '6480'").update_all("value = '07'")
		SystemParam.where("system_param_categories_id = 25 and key = '6479'").update_all("value = '07'")
		SystemParam.where("system_param_categories_id = 25 and key = '6478'").update_all("value = '07'")
		SystemParam.where("system_param_categories_id = 25 and key = '6477'").update_all("value = '07'")
		SystemParam.where("system_param_categories_id = 25 and key = '6476'").update_all("value = '07'")
		SystemParam.where("system_param_categories_id = 25 and key = '6481'").update_all("value = '08'")
		SystemParam.where("system_param_categories_id = 25 and key = '6482'").update_all("value = '09'")
	end
end