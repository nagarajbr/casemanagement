class AddressEntityService

# client address
	def self.get_mailing_address_from_client_id(arg_client_id)
		get_address_from_client_id(arg_client_id, 4665)

	end

    def self.get_physical_address_from_client_id(arg_client_id)
		get_address_from_client_id(arg_client_id, 4664)

	end

	def self.get_address_from_client_id(arg_client_id, arg_entity_type)
		step1 = Address.joins("inner join entity_addresses on entity_addresses.address_id = addresses.id")
        step2 = step1.where("entity_addresses.entity_type = 6150 and entity_addresses.entity_id = ? and addresses.address_type = ?  ",arg_client_id,arg_entity_type)
        step3 = step2.select("addresses.*")
        return step3
	end


#provider address
   def self.get_mailing_address_from_provider_id(arg_provider_id)
		get_address_from_provider_id(arg_provider_id, 4665)

	end

    def self.get_physical_address_from_provider_id(arg_provider_id)
		get_address_from_provider_id(arg_provider_id, 4664)

	end

	def self.get_address_from_provider_id(arg_provider_id, arg_entity_type)
		step1 = Address.joins("inner join entity_addresses on entity_addresses.address_id = addresses.id")
        step2 = step1.where("entity_addresses.entity_type = 6151 and entity_addresses.entity_id = ? and addresses.address_type = ?  ",arg_provider_id,arg_entity_type)
        step3 = step2.select("addresses.*")
        return step3
   	end

#Employer address
	def self.get_mailing_address_from_employer_id(arg_employer_id)
		get_address_from_employer_id(arg_employer_id, 4665)

	end

    def self.get_physical_address_from_employer_id(arg_employer_id)
		get_address_from_employer_id(arg_employer_id, 4664)

	end

	def self.get_address_from_employer_id(arg_employer_id, arg_entity_type)
		step1 = Address.joins("inner join entity_addresses on entity_addresses.address_id = addresses.id")
        step2 = step1.where("entity_addresses.entity_type = 6152 and entity_addresses.entity_id = ? and addresses.address_type = ?  ",arg_employer_id,arg_entity_type)
        step3 = step2.select("addresses.*")
        return step3
    end

  #school address
	def self.get_mailing_address_from_school_id(arg_school_id)
		get_address_from_school_id(arg_school_id, 4665)

	end

    def self.get_physical_address_from_school_id(arg_school_id)
		get_address_from_school_id(arg_school_id, 4664)

	end

	def self.get_address_from_school_id(arg_school_id, arg_entity_type)
		step1 = Address.joins("inner join entity_addresses on entity_addresses.address_id = addresses.id")
        step2 = step1.where("entity_addresses.entity_type = 6338 and entity_addresses.entity_id = ? and addresses.address_type = ?  ",arg_school_id,arg_entity_type)
        step3 = step2.select("addresses.*")
        return step3

	end




end