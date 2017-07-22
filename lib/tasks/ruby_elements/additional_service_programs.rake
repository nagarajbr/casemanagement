namespace :additional_service_programs do
	desc "Additional Service Programs"
	task :additional_service_programs => :environment do
		ServiceProgram.create(description:'Financial Assistance',title:'Financial Assistance',sanction_indicator:'N',created_by: 1,updated_by: 1)
		ServiceProgram.create(description:'Food Assistance',title:'Food Assistance',sanction_indicator:'N',created_by: 1,updated_by: 1)
		ServiceProgram.create(description:'Medical Assistance',title:'Medical Assistance',sanction_indicator:'N',created_by: 1,updated_by: 1)
	end
end