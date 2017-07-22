class AgencyReferral < ActiveRecord::Base

	def self.is_the_client_previously_referred_to_ocse(arg_client_id)
		where("entity_type = 6150 and entity_id = ? and agency_type = 6514",arg_client_id).count > 0
	end
end
