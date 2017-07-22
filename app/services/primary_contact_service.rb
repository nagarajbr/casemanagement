class PrimaryContactService
	def self.save_primary_contact(arg_reference_id, arg_reference_type, arg_client_id)
		can_save_primary_contact = false
		primary_contact = PrimaryContact.where("reference_id = ? and reference_type = ?",arg_reference_id, arg_reference_type)
		if primary_contact.present?
			primary_contact = primary_contact.first
			can_save_primary_contact = true if primary_contact.client_id != arg_client_id
		else
			primary_contact = PrimaryContact.new
			primary_contact.reference_id = arg_reference_id
			primary_contact.reference_type = arg_reference_type
			can_save_primary_contact = true
		end
		primary_contact.client_id = arg_client_id
		primary_contact.save! if can_save_primary_contact
	end
end