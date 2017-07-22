namespace :cost_center_information do
	desc "create cost center info"
	task :create_cost_center_information => :environment do

		connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.cost_centers")
    	connection.execute("SELECT setval('public.cost_centers_id_seq', 1, true)")

    	user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

    	# TEA service programs
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6325 ,threshold_amount: 200.00)
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6222 ,threshold_amount: 999.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6217 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6216 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6215 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6213 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6212 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6211 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6210 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6209 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6208 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6207 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6206 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6205 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6204 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6203 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6362 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6361 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6360 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6359 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6327 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6326 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6324 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6323 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6322 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6321 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6293 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6292 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6291 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6290 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6289 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6287 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6286 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6285 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 1,cost_center: "426697",internal_order:"I0810EJ61",gl_account:"5100001000" ,service_type: 6284 ,threshold_amount: 200.00 )

		#Workpays service programs
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6325 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6222 ,threshold_amount: 999.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6217 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6216 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6215 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6213 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6212 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6211 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6210 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6209 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6208 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6207 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6206 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6205 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6204 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6203 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6362 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6361 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6360 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6359 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6327 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6326 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6324 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6323 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6322 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6321 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6293 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6292 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6291 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6290 ,threshold_amount: 200.00 )

		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6289,threshold_amount: 200.00)
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6287 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6286 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6285 ,threshold_amount: 200.00 )
		CostCenter.create(service_program_group: 4,cost_center: "426696",internal_order:"I0810WP71",gl_account:"5100001000" ,service_type: 6284 ,threshold_amount: 200.00 )
	end
end
