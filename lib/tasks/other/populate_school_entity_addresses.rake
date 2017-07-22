namespace :populate_school_entity_address do
	desc "Populate Schools Entity Address"
	task :populate_schools_entity_address => :environment do
		connection = ActiveRecord::Base.connection()
		connection.execute("delete from entity_addresses where entity_addresses.entity_type = 6338")

        step1= School.joins("INNER JOIN  addresses on (schools.school_name = addresses.address_line1
         											and schools.school_type= CAST(nullif(addresses.in_care_of, '' ) AS integer)
         											and addresses.address_notes = 'SchoolName') ")
        step2 = step1.select("schools.id as entity_id, addresses.id as address_id")
        step2.each do |each_entity_address|
            entity_address_object = EntityAddress.new
            entity_address_object.entity_type = 6338
            # Rails.logger.debug("each_entity_address.entity_id = #{each_entity_address.entity_id}")
            entity_address_object.entity_id = each_entity_address.entity_id
            entity_address_object.address_id = each_entity_address.address_id
            entity_address_object.save
        end
    end
end