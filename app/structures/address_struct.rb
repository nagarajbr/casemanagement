class AddressStruct
	#  Author Kiran
	#  Modifications : Manoj Patil 09/26/2014
	#  Modification Description: Added case_type_integer to reflect code table number- which will be populated in Program_unit table.
	# Modified by Manoj 09/30/2014 - Added program_unit_id
	attr_accessor :address_parameters, :entity_obj, :addresses_error_messages_obj, :address_obj, :mailing_address_changed, :non_mailing_address_changed,
				  :is_there_an_address_change, :entity_type, :prev_mailing_address_type, :prev_non_mailing_address_type, :exception_msg, :can_save, :client_id
end