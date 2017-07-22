class Barrier < ActiveRecord::Base

	def self.get_description(arg_id)
		barrier = find(arg_id)
		if barrier.present?
			return barrier.description
		else
			return ""
		end
	end
end
