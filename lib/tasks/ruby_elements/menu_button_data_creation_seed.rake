namespace :menu_button_data_creation_seed do
	desc "Creating menu and access rights"
	task :create_menu_and_access_rights => :environment do
		connection = ActiveRecord::Base.connection()

   		#1. Truncate & restart sequence
   		connection.execute("TRUNCATE TABLE public.ruby_element_reltns")
   		connection.execute("ALTER SEQUENCE public.ruby_element_reltns_id_seq RESTART WITH 1")

     	connection.execute("TRUNCATE TABLE public.ruby_elements")
     	connection.execute("ALTER SEQUENCE public.ruby_elements_id_seq RESTART WITH 1")

     	connection.execute("TRUNCATE TABLE public.access_rights")
     	connection.execute("ALTER SEQUENCE public.access_rights_id_seq RESTART WITH 1")

     	#2. Initial Menu/menu relation insert script


     	# 3. invoke other rake tasks (Menu/button/access rights)
     	# Rake::Task["populate_codetable1:phone_type_state"].invoke



	end
end