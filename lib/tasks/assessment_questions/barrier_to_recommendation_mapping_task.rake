namespace :barrier_to_recommendation_mapping_task do
	desc "barrier_to_recommendation_mapping"
	task :populate_barrier_to_recommendation_mapping => :environment do
		connection = ActiveRecord::Base.connection()
    	connection.execute("TRUNCATE TABLE public.standard_recommendations")
    	connection.execute("SELECT setval('public.standard_recommendations_id_seq', 1, true)")

		StandardRecommendation.create(barrier_id:3,recommendation_id:4,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:2,recommendation_id:5,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:6,recommendation_id:6,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:5,recommendation_id:7,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:4,recommendation_id:8,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:7,recommendation_id:9,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:8,recommendation_id:10,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:9,recommendation_id:11,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:27,recommendation_id:13,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:10,recommendation_id:12,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:19,recommendation_id:14,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:18,recommendation_id:16,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:17,recommendation_id:17,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:11,recommendation_id:18,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:23,recommendation_id:19,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:22,recommendation_id:20,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:21,recommendation_id:21,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:26,recommendation_id:22,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:25,recommendation_id:23,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:16,recommendation_id:24,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:14,recommendation_id:25,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:12,recommendation_id:26,created_by: 1,updated_by: 1)
		StandardRecommendation.create(barrier_id:30,recommendation_id:3,created_by: 1,updated_by: 1)

	end
end




























