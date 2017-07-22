namespace :update_access_rights_for_provider_payment_management do
	desc "Updating access rights for provider payment is 'Y' for manager "
	task :update_access_rights_for_provider_payment_management => :environment do
	AccessRight.where("role_id in (6) and id in (3306,3302,3304)").update_all("access = 'Y'")


   end
end