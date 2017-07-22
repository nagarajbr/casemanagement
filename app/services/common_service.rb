class CommonService
	# Author : Manoj Patil
	#Description: common model methods

	def set_empty_attributes_to_nil(arg_model)
		# This method makes sure - empty string does not save in the database.
		# example: SSN - empty string was getting saved in the database- it was giving unique constraint error - while saving nil SSNs
		# hence this method.
    	arg_model.attributes.each do |key,value|
			arg_model[key] = nil if value.blank?
        end
	end

	def self.strip_spaces_and_downcase(arg_string)
		return arg_string.strip.downcase
	end
end