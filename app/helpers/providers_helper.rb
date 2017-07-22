module ProvidersHelper

	def get_provider_city(arg_id)
		if arg_id.present?
			provider_city_collection = Provider.get_provider_city(arg_id)
			if provider_city_collection.present?
				provider_city_object = provider_city_collection.first
				ls_out = provider_city_object.city
			else
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end
end
