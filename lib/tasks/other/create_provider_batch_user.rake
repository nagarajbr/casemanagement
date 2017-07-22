namespace :create_provider_batch_user do
	desc "Creating Provider Users"
	task :create_provider_batch_user => :environment do
		connection = ActiveRecord::Base.connection()
		connection.execute("delete from provider_app_users")
		connection.execute("ALTER SEQUENCE public.provider_app_users_id_seq RESTART WITH 1")
		ProviderAppUser.create(name:"Batch User",created_by:555,updated_by:555,permissions:["signin","Specialist","Manager"],uid:555,organisation_slug: 'Little Rock Workforce Center')
	end
end