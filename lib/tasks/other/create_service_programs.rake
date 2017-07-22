namespace :populate_service_programs do
	desc "Populate Service Programs Table"
	task :TANF_service_programs => :environment do
		connection = ActiveRecord::Base.connection()
		connection.execute("delete from service_programs")
		connection.execute("ALTER SEQUENCE public.service_programs_id_seq RESTART WITH 1")

		# 1.
		ServiceProgram.create(description:"TEA",title:"TEA",sanction_indicator: "Y",created_by: 1,updated_by: 1)
		# 2.
		ServiceProgram.create(description:"TEA Relocation",title:"TEA Relocation",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 3.
		ServiceProgram.create(description:"TEA Diversion",title:"TEA Diversion",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 4.
		ServiceProgram.create(description:"Work Pays",title:"Work Pays",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 5.
		ServiceProgram.create(description:"Unemployment Insurance",title:"UI",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 6.
		ServiceProgram.create(description:"Trade Readjustment Allowances",title:"TRA",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 7.
		ServiceProgram.create(description:"Trade Adjustment Assistance",title:"TAA",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 8.
		ServiceProgram.create(description:"Emergency Unemployment Compensation",title:"EUC",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 9.
		ServiceProgram.create(description:"Disabled Veterans Outreach Program",title:"DVOP",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 10.
		ServiceProgram.create(description:"Low Income Heat and Electricity Assistance Program",title:"LIHEAP",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 11.
		ServiceProgram.create(description:"Arkansas Veteran Education & Training Program",title:"AVET",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 12.
		ServiceProgram.create(description:"Mature Workers Initiative",title:"MWI",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 13.
		ServiceProgram.create(description:"Career Readiness Certification",title:"CRC",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 14.
		ServiceProgram.create(description:"IT Academy",title:"IT Academy",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 15.
		ServiceProgram.create(description:"Youth Program",title:"Youth Program",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 16.
		ServiceProgram.create(description:"Workforce Investment Act",title:"WIA",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 12/14/2015 -START
		# 17.
		ServiceProgram.create(description:"Food (SNAP)",title:"Food (SNAP)",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 18.
		ServiceProgram.create(description:"Food Assistance",title:"Food Assistance",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 19.
		ServiceProgram.create(description:"Medical Assistance",title:"Medical Assistance",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 20.
		ServiceProgram.create(description:"Financial Assistance",title:"Financial Assistance",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 21.
		ServiceProgram.create(description:"test service program1",title:"test service program1",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 22.
		ServiceProgram.create(description:"test service program2",title:"test service program2",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 23.
		ServiceProgram.create(description:"Medical (HCIP)",title:"Medical (HCIP)",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 24.
		ServiceProgram.create(description:"Food with E&T (SNAP)",title:"Food with E&T (SNAP)",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 25.
		ServiceProgram.create(description:"Food with voluntary E&T (SNAP)",title:"Food with voluntary E&T (SNAP)",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 26.
		ServiceProgram.create(description:"Cash and work support (TANF)",title:"Cash and work support (TANF)",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 27.
		ServiceProgram.create(description:"Workforce Investment programs",title:"Workforce Investment programs",sanction_indicator: "N",created_by: 1,updated_by: 1)
		# 28.
		ServiceProgram.create(description:"Job search services",title:"Job search services",sanction_indicator: "N",created_by: 1,updated_by: 1)

		# 12/14/2015 -END
		ServiceProgram.where("id in (1,3,4)").update_all(svc_pgm_category: 6015)
   		ServiceProgram.where("id = 2").destroy_all



	end

end
