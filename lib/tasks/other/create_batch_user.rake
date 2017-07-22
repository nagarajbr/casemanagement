namespace :create_batch_user do
	desc "Creating Users"
	task :create_batch_user => :environment do
		connection = ActiveRecord::Base.connection()
		connection.execute("delete from users")
		connection.execute("ALTER SEQUENCE public.users_id_seq RESTART WITH 1")
		User.create(name:"Batch User",created_by:1,updated_by:1,permissions:["signin","Specialist","Manager"],uid:555,organisation_slug: 'Little Rock Workforce Center')
	end
end


