class StandardRecommendation < ActiveRecord::Base
	def self.get_standard_recommendation_for_barrier(arg_barrier_id)
		where("barrier_id = ?",arg_barrier_id)

	end
end
